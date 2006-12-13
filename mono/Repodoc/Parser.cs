/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;

namespace Repodoc
{
	public abstract class ParserTask {
		private string boundary_docs;
		private System.IO.TextReader tIn;

		abstract public void on_parse_all_pre();
		abstract public void on_parse_document_pre();
		abstract public void on_parse_document_kv(string k, string v);
		abstract public void on_parse_module_all_pre();
		abstract public void on_parse_module_pre();
		abstract public void on_parse_module_name(string name);
		abstract public void on_parse_module_ok();
		abstract public void on_parse_module_warning();
		abstract public void on_parse_module_critical();
		abstract public void on_parse_module_output(string output);
		abstract public void on_parse_module_post();
		abstract public void on_parse_module_all_post();
		abstract public void on_parse_document_post();
		abstract public void on_parse_all_post();

		public ParserTask(System.IO.TextReader t)
		{
			tIn = t;
		}

		public void run()
		{
			boundary_docs = tIn.ReadLine();
			parse_docs();
		}

		private void parse_docs()
		{
			on_parse_all_pre();

			while (parse_doc())
				/* empty */;

			on_parse_all_post();
		}

		private bool parse_doc()
		{
			string boundary_doc = tIn.ReadLine();
			if (boundary_doc == null)
				return false;

			on_parse_document_pre();

			string s;
			while ((s = tIn.ReadLine()) != boundary_doc) {
				int space = s.IndexOf(' ');
				string k = s.Substring(0, space);
				string v = s.Substring(space + 1);
				on_parse_document_kv(k, v);
			}

			on_parse_module_all_pre();

			while (s != boundary_docs) {
				s = tIn.ReadLine();
				if (s == boundary_docs)
					break;
				else if (s == boundary_doc) {
					on_parse_module_post();
					continue;
				} else if (s == null)
					break;
				on_parse_module_pre();

				on_parse_module_name(s);
				int res = Convert.ToInt32(tIn.ReadLine());
				switch (res) {
					case 0:
						on_parse_module_ok();
						break;
					case 1:
						on_parse_module_warning();
						break;
					case 2:
						on_parse_module_critical();
						break;
				}
				string output = "";
				while ((s = tIn.ReadLine()) != boundary_doc) {
					if (s == null || s == boundary_docs)
						break;
					output = output + s + "\n";
				}
				on_parse_module_output(output);

				on_parse_module_post();
			}

			on_parse_module_all_post();

			on_parse_document_post();

			return true;
		}
	}
}
