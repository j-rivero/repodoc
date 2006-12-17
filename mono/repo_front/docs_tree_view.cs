/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;
using System.Collections.Generic;
using Repodoc;

class DocsTreeView : Gtk.TreeView {
	public Gtk.TextView tv;

	public DocsTreeView(Gtk.TextView rtv, OurParserTask r)
	{
		tv = rtv;
		AppendColumn("Name", new Gtk.CellRendererText());
		AppendColumn("Result", new Gtk.CellRendererPixbuf());

		RulesHint = true;

		Columns[0].SetCellDataFunc(Columns[0].CellRenderers[0],
				new Gtk.TreeCellDataFunc(RenderName));
		Columns[1].SetCellDataFunc(Columns[1].CellRenderers[0],
				new Gtk.TreeCellDataFunc(RenderIcon));

		Columns[0].Expand = true;

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
		IParsed n = (IParsed)model.GetValue(iter, 0);

		if (model.IterHasChild(iter) || n.Result == 0)
			(cell as Gtk.CellRendererText).FontDesc =
				Pango.FontDescription.FromString("Bold");
		else
			(cell as Gtk.CellRendererText).FontDesc =
				Pango.FontDescription.FromString("Normal");

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


