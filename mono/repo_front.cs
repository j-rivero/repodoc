/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;
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

class DocsTreeView : Gtk.TreeView {
	public DocsTreeView(OurParserTask r)
	{
		AppendColumn("",
				new Gtk.CellRendererPixbuf(),
				"stock-id",
				0);
		AppendColumn("Document/Module name",
				new Gtk.CellRendererText(),
				"text",
				1);
		Gtk.TreeStore nameListStore = new Gtk.TreeStore(
				typeof (string), typeof (string));
		Model=nameListStore;
		
		Gtk.TreeIter iter = new Gtk.TreeIter();
		foreach (ParsedDocument doc in r.Docs) {
			iter = nameListStore.AppendValues(
					Icon(TotalResult(doc)), DocName(doc));

			foreach (ModuleResult m in doc.Results) {
				if (m.Result > 0)
					nameListStore.AppendValues(iter,
							Icon(m.Result),
							m.Name);
			}
		}
	}

	public string Icon(int result)
	{
		switch(result)
		{
			case 0: return Gtk.Stock.DialogInfo;
			case 1: return Gtk.Stock.DialogWarning;
			case 2: return Gtk.Stock.DialogError;
		}
		throw new Exception("Unknown result value");
	}

	public int TotalResult(ParsedDocument doc)
	{
		int r = 0;
		foreach (ModuleResult m in doc.Results)
			r = Math.Max(m.Result, r);
		return r;
	}

	public string DocName(ParsedDocument doc)
	{
		string dir = doc.Keys["DIR"];

		return dir.Substring(dir.LastIndexOf("/doc/") + 1) +
			"/" + doc.Keys["DOC_NAME"];
	}
}

class repo_front {
	static void Main(string[] args)
	{
		OurParserTask r = new OurParserTask(Console.In);
		r.run();

		Gtk.Application.Init();
		DocsTreeView t = new DocsTreeView(r);
		Gtk.Window window = new Gtk.Window("Repodoc - Gtk# frontend");
		Gtk.ScrolledWindow sw = new Gtk.ScrolledWindow();
		sw.Add(t);
		window.Add(sw);
		window.SetDefaultSize(400, 300);
		window.DeleteEvent += delete_event;
		window.ShowAll();
		Gtk.Application.Run();
	}

	static void delete_event (object obj, Gtk.DeleteEventArgs args)
	{
		Gtk.Application.Quit();
	}
}
