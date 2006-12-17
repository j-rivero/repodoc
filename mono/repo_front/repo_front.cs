/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;

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
		tv.CursorVisible = false;

		Pango.FontDescription fontdesc = 
			Pango.FontDescription.FromString("Monospace");
		tv.ModifyFont(fontdesc);

		DocsTreeView t = new DocsTreeView(tv, r);
		sw.Add(t);

		Gtk.VPaned vp = new Gtk.VPaned();
		vp.BorderWidth = 6;
		vp.Pack1(sw, true, true);
		window.Add(vp);

		Gtk.ScrolledWindow sw2 = new Gtk.ScrolledWindow();
		sw2.Add(tv);
		vp.Pack2(sw2, true, true);

		window.SetDefaultSize(500, 400);
		window.DeleteEvent += delete_event;
		window.ShowAll();

		Gtk.Application.Run();
	}

	static void delete_event (object obj, Gtk.DeleteEventArgs args)
	{
		Gtk.Application.Quit();
	}
}
