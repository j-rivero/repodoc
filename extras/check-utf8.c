/*
 * Copyright (c) 2004 Ciaran McCreesh <ciaranm@gentoo.org>
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

/* 
 * Addapted for repodoc use by Fernando J. Pereda <ferdy@gentoo.org> 
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#define ERR_FILE 1
#define ERR_CHAR 2

/*
 * Check a single file for validity. Returns 0 for no errors found or ERR_CHAR
 * if a bad character is present. If verbose, displays details of any errors
 * found. f must be a valid filehandle which has been opened for read.
 */
    int
check_opened_file(FILE *f, const char *display_name, int verbose, int snippet)
{
    int       c;                     /* byte read                                */
    int       result           = 0;  /* any nasties?                             */
    unsigned  line             = 1;  /* current line number                      */
    unsigned  offset           = 0;  /* byte offset in current line              */
    unsigned  err_c            = 0;  /* how many errors?                         */
    int       done_file_header = 0;  /* already displayed the In file: header?   */

    const int buf_sz           = 40; /* buffer entries to keep                   */
    char      buf[buf_sz + 1];       /* buffer of what we've read in             */
    int       buf_idx          = 0;  /* index to current character in the buffer */
    memset(buf, 0, buf_sz);

    /* get the next character. take care of the buffer. */
    int next_char(FILE *f) {
        int c = fgetc(f);
        if (EOF != c)
        {
            ++offset;
            buf[buf_idx] = c;
            if (buf_idx >= buf_sz)
            {
                memmove(buf, buf + 1, buf_sz);
            }
            else
                ++buf_idx;
        }
        return c;
    }

    /* iterate over the file byte at a time */
    while (EOF != ((c = next_char(f))))
    {
        if (err_c > ((verbose || snippet) ? 10 : 1))
        {
            if (verbose || snippet)
                printf("Too many errors, bailing out\n");
            break;
        }

        if (c == '\n')
        {
            /* we got a newline */
            offset = 0;
            buf_idx = 0;
            ++line;
        }
        else if (c > 127)
        {
            /* we got a byte which needs special processing */

            /* work out how many extra 10?? ???? characters we should have */
            unsigned extras = 0;
            if (0xc0 == (c & 0xe0))
                extras = 1;
            else if (0xe0 == (c & 0xf0))
                extras = 2;
            else if (0xf0 == (c & 0xf8))
                extras = 3;
            else
            {
                /* we found an invalid start character */
                if (verbose || snippet)
                {
                    if (0 == done_file_header++)
                        printf("In file %s:\n", display_name);
                    printf("    Bad character 0x%2.2x at line %d offset %d\n",
                            c, line, offset);
                }

                /* show a snippet? */
                if (snippet && (buf_idx > 1))
                {
                    buf[buf_idx - 1] = '\0';
                    printf("    Leading text: %s\n", buf);
                }
                buf_idx = 0;

                /* we have errors */
                result |= ERR_CHAR;
                ++err_c;
            }

            /* check extra 10?? ???? characters */
            unsigned i;
            for (i = 0 ; i < extras ; ++i)
            {
                c = next_char(f);

                if (EOF == c)
                {
                    /* we hit an EOF. not good. */
                    result |= ERR_CHAR;
                    if (verbose || snippet)
                    {
                        if (0 == done_file_header++)
                            printf("In file %s:\n", display_name);
                        printf("    Unexpected EOF inside UTF-8 sequence\n");
                    }

                    /* show a snippet? */
                    if (snippet && (buf_idx > (i + 2)))
                    {
                        buf[buf_idx - i - 2] = '\0';
                        printf("    Leading text: %s\n", buf);
                    }
                    buf_idx = 0;

                    ++err_c;
                    break;
                }
                if ((c & 0x80) != 0x80)
                {
                    /* we hit a bad character */
                    if (verbose || snippet)
                    {
                        if (0 == done_file_header++)
                            printf("In file %s:\n", display_name);
                        printf("    Bad character 0x%2.2x inside UTF-8 sequence",
                                c);
                        printf(" (%d/%d) at line %d offset %d\n",
                                i + 2, extras + 1, line, offset - i - 1);
                    }

                    /* show a snippet? */
                    if (snippet && (buf_idx > (i + 2)))
                    {
                        buf[buf_idx - i - 2] = '\0';
                        printf("    Leading text: %s\n", buf);
                    }
                    buf_idx = 0;

                    result |= ERR_CHAR;
                    ++err_c;

                    /* skip to EOL to recover to avoid generating many messages
                     * for a single error */
                    while (EOF != ((c = fgetc(f))))
                        if (c == '\n')
                            break;
                    ++line;
                    offset = 0;
                    buf_idx = 0;

                    break;
                }
            }
        }
    }
    return result;
}

/*
 * Main program.
 */
int main(int argc, char *argv[])
{
    FILE *file;

    /* read either file or stdin */
    file = (argc==1 ? stdin : fopen(argv[1],"r"));

    return "%d\n",check_opened_file(file,(argc==1 ? "stdin" : argv[1]),1,1);
}
/* vim: set ft=c fileencoding=utf-8 tw=80 sw=4 et : */
