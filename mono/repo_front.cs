/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;
using System.Collections;
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

class repo_front {
	static void Main(string[] args)
	{
		OurParserTask r = new OurParserTask(System.Console.In);
		r.run();

		foreach (ParsedDocument doc in r.Docs) {
			foreach (KeyValuePair<string, string> e in doc.Keys)
				Console.WriteLine("'{0}' = '{1}'",
						e.Key, e.Value);
			foreach (ModuleResult m in doc.Results)
				Console.WriteLine("Module '{0}' - '{1}'",
						m.Name, m.Result);
		}
	}
}
