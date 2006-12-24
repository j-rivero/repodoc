/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

/* Copyright (C) 2006-2007 The Repodoc Team
 *
 * This file is part of Repodoc.
 *
 * Repodoc is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License.
 *
 * Repodoc is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Repodoc; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

using System.Collections.Generic;
using Repodoc;

class OurParserTask : ParserTask {
	private IList<ParsedDocument> docs;
	private ParsedDocument current_doc;
	private ModuleResult current_mod;

	public OurParserTask(System.IO.TextReader t) :
		base(t)
	{
		docs = new List<ParsedDocument>();
	}

	public IList<ParsedDocument> Docs
	{
		get { return docs; }
	}

	public override void on_parse_all_pre()
	{
	}

	public override void on_parse_document_pre()
	{
		current_doc = new ParsedDocument();
	}

	public override void on_parse_document_kv(string k, string v)
	{
		current_doc.Keys.Add(k, v);
	}

	public override void on_parse_module_all_pre()
	{
	}

	public override void on_parse_module_pre()
	{
		current_mod = new ModuleResult();
	}

	public override void on_parse_module_name(string name)
	{
		current_mod.Name = name;
	}

	public override void on_parse_module_ok()
	{
		current_mod.Result = 0;
	}

	public override void on_parse_module_warning()
	{
		current_mod.Result = 1;
	}

	public override void on_parse_module_critical()
	{
		current_mod.Result = 2;
	}

	public override void on_parse_module_output(string output)
	{
		current_mod.Output = output;
	}

	public override void on_parse_module_post()
	{
		current_doc.Results.Add(current_mod);
	}

	public override void on_parse_module_all_post()
	{
	}

	public override void on_parse_document_post()
	{
		docs.Add(current_doc);
	}

	public override void on_parse_all_post()
	{
	}
}
