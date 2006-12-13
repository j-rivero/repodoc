/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;
using System.Collections.Generic;

namespace Repodoc
{
	public interface IParsed {
		int Result { get; }
		string Output { get; }
	}

	public interface INamed {
		string Name { get; }
	}

	public class ModuleResult : IParsed, INamed {
		private string name;
		private int result;
		private string output;

		public string Name
		{
			get { return name; }
			set { name = value; }
		}

		public int Result
		{
			get { return result; }
			set { result = value; }
		}

		public string Output
		{
			get { return output; }
			set { output = value; }
		}
	}

	public class ParsedDocument : IParsed, INamed {
		private IDictionary<string, string> keys;
		private IList<ModuleResult> results;

		public ParsedDocument()
		{
			keys = new Dictionary<string, string>();
			results = new List<ModuleResult>();
		}

		public string Name
		{
			get {
				string dir = Keys["DIR"];

				return dir.Substring(
						dir.LastIndexOf("/doc/") + 1)
					+ "/" + Keys["DOC_NAME"];
			}
		}

		public IDictionary<string, string> Keys
		{
			get { return keys; }
		}

		public IList<ModuleResult> Results
		{
			get { return results; }
		}

		public int Result
		{
			get {
				int r = 0;
				foreach (IParsed i in Results)
					r = Math.Max(i.Result, r);
				return r;
			}
		}

		public string Output
		{
			get {
				bool nl = false;
				string o = "";
				foreach (KeyValuePair<string, string> i 
						in Keys) {
					if (nl == true)
						o += "\n";
					o += "'" + i.Key + "' = '" +
						i.Value + "'";
					nl = true;
				}
				return o;
			}
		}
	}
}
