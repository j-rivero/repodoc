/*
 * Copyright (c) 2006 Fernando J. Pereda <ferdy@gentoo.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

#if !defined(LIBXML_XPATH_ENABLED) || !defined(LIBXML_SAX1_ENABLED)
#        error "Need libxml2 built with SAX and XPath."
#endif

static void oom(void);
static void usage(char*);
static int process_file(char*, int, char**);
static int run_xpath_expression(xmlXPathContextPtr, const char*);
static void node_walk(xmlNodeSetPtr);

int main(int argc, char *argv[])
{
	int i, startexprs=2;

	if (argc < 3) {
		fprintf(stderr, "Fatal: Incorrect number of arguments.\n");
		usage(argv[0]);
		exit(EXIT_FAILURE);
	}

	/*
	 * We calculate the number of files by assuming the first argument that
	 * is not a file is the first XPath expression. This is probably assuming
	 * much for regular user usage. But this is meant to be used *inside*
	 * RepoDoc. We start in argv[2] because argv[1] is meant to be a file
	 * anyway.
	 */
	for (i = 2; i < argc; i++) {
		struct stat ftmp;
		if (stat(argv[i], &ftmp) < 0)
			break;
		startexprs++;
	}

	xmlInitParser();

	for (i = 1; i < startexprs; i++)
		if (process_file(argv[i], argc-startexprs, argv+startexprs) < 0) {
			xmlCleanupParser();
			fprintf(stderr, "Fatal: Error while processing file #%d.\n", i);
			exit(EXIT_FAILURE);
		}

	xmlCleanupParser();

	exit(EXIT_SUCCESS);
}

static void usage(char *me)
{
	char *p = strrchr(me, '/');

	if (p == NULL)
		p = me;
	else
		p++;

	fprintf(stderr, "Usage: %s <files> <xpath expressions>\n", p);

	return;
}

static void oom(void)
{
	fprintf(stderr, "Out of memory!\n");
	exit(EXIT_FAILURE);
}

static int process_file(char *path, int n_exprs, char *exprs[])
{
	xmlDocPtr document;
	xmlXPathContextPtr xpathCtx;
	int i;

	if ((document = xmlParseFile(path)) == NULL) {
		fprintf(stderr, "Fatal: Unable to parse '%s'.\n", path);
		return -1;
	}

	if ((xpathCtx = xmlXPathNewContext(document)) == NULL) {
		xmlFreeDoc(document);
		fprintf(stderr, "Fatal: Unable to create a new XPath context.\n");
		return -1;
	}

	for (i = 0; i < n_exprs; i++)
		if (run_xpath_expression(xpathCtx, exprs[i]) < 0) {
			xmlFreeDoc(document);
			fprintf(stderr, "Fatal: Error while evaluating "
					"XPath expression #%d.\n", i);
			return -1;
		}

	xmlXPathFreeContext(xpathCtx);
	xmlFreeDoc(document);

	return 1;
}

static int run_xpath_expression(xmlXPathContextPtr ctx, const char *expr)
{
	xmlChar *xpathExpr;
	xmlXPathObjectPtr xpathObj;

	if ((xpathExpr = xmlCharStrdup(expr)) == NULL)
		oom();

	if ((xpathObj = xmlXPathEvalExpression(xpathExpr, ctx)) == NULL) {
		xmlXPathFreeContext(ctx);
		free(xpathExpr);
		fprintf(stderr, "Fatal: Please learn XPath.\n");
		return -1;
	}

	switch (xpathObj->type) {
		case XPATH_NODESET:
			node_walk(xpathObj->nodesetval);
			break;
		case XPATH_NUMBER:
			printf("%d\n", (int)(xpathObj->floatval));
			break;
		case XPATH_STRING:
			printf("%s\n", xpathObj->stringval);
			break;
		case XPATH_BOOLEAN:
			printf("%s\n", (xpathObj->boolval ? "True" : "False"));
			break;
		default:
			printf("I don't know how to handle "
					"XPathObject type %d.\n", xpathObj->type);
			break;
	}

	xmlXPathFreeObject(xpathObj);
	free(xpathExpr);

	return 1;
}

static void node_walk(xmlNodeSetPtr n)
{
	int i;
	xmlNodePtr nd;

	/* Empty set, stop walking */
	if (!n)
		return;

	for (i = 0; i < n->nodeNr; i++) {
		nd = n->nodeTab[i];

		switch (nd->type) {
			case XML_ATTRIBUTE_NODE:
				printf("%s\n", nd->children->content);
				break;
			case XML_ELEMENT_NODE:
				printf("%s\n", nd->name);
				break;
			case XML_TEXT_NODE:
				printf("%s\n", nd->content);
				break;
			default:
				printf("I don't know how to handle Node type %d.\n",
						nd->type);
				break;
		}
	}

	return;
}
