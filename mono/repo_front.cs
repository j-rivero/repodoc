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
	public Gtk.TextView tv;

	public DocsTreeView(Gtk.TextView rtv, OurParserTask r)
	{
		tv = rtv;
		AppendColumn("Result", new Gtk.CellRendererPixbuf());
		AppendColumn("Name", new Gtk.CellRendererText());

		Columns[0].SetCellDataFunc(Columns[0].CellRenderers[0],
				new Gtk.TreeCellDataFunc(RenderIcon));
		Columns[1].SetCellDataFunc(Columns[1].CellRenderers[0],
				new Gtk.TreeCellDataFunc(RenderName));

		Gtk.TreeStore mres_store = new Gtk.TreeStore(
				typeof(IParsed));
		Model = mres_store;

		Selection.Changed += new EventHandler(OnSelection);
		
		Gtk.TreeIter iter = new Gtk.TreeIter();
		foreach (ParsedDocument doc in r.Docs) {
			iter = mres_store.AppendValues(doc);
			foreach (IParsed m in doc.Results)
				if (m.Result > 0)
					mres_store.AppendValues(iter, m);
		}
	}

	private void RenderIcon(
			Gtk.TreeViewColumn column,
			Gtk.CellRenderer cell,
			Gtk.TreeModel model,
			Gtk.TreeIter iter)
	{
		IParsed m = (IParsed)model.GetValue(iter, 0);
		(cell as Gtk.CellRendererPixbuf).StockId = Icon(m);
	}

	private void RenderName(
			Gtk.TreeViewColumn column,
			Gtk.CellRenderer cell,
			Gtk.TreeModel model,
			Gtk.TreeIter iter)
	{
		INamed m = (INamed)model.GetValue(iter, 0);
		(cell as Gtk.CellRendererText).Text = m.Name;
	}

	public string Icon(IParsed m)
	{
		switch (m.Result)
		{
			case 0: return Gtk.Stock.DialogInfo;
			case 1: return Gtk.Stock.DialogWarning;
			case 2: return Gtk.Stock.DialogError;
		}
		throw new Exception("Unknown result value");
	}

	private void OnSelection(object o, EventArgs args)
        {
                Gtk.TreeModel model;
                Gtk.TreeIter iter;
                IParsed selected = null;

                if (Selection.GetSelected(out model, out iter)) {
			selected = (IParsed)model.GetValue(iter, 0);
			tv.Buffer.Text = selected.Output;
		}
        }
}

class repo_front {
	static void Main(string[] args)
	{
		OurParserTask r = new OurParserTask(Console.In);
		r.run();

		Gtk.Application.Init();

		Gtk.Window window = new Gtk.Window("Repodoc - Gtk# frontend");
		Gtk.ScrolledWindow sw = new Gtk.ScrolledWindow();

		Gtk.TextView tv = new Gtk.TextView();
		tv.Editable = false;

		Pango.FontDescription fontdesc = Pango.FontDescription.FromString("Monospace");
		tv.ModifyFont(fontdesc);

		DocsTreeView t = new DocsTreeView(tv, r);
		sw.Add(t);

		Gtk.VPaned vp = new Gtk.VPaned();
		vp.Add(sw);
		window.Add(vp);

		Gtk.ScrolledWindow sw2 = new Gtk.ScrolledWindow();
		sw2.Add(tv);
		vp.Add(sw2);

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
