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
