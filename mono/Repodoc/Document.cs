/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using System;
using System.Collections.Generic;

namespace Repodoc
{
	public class ModuleResult {
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

	public class ParsedDocument {
		private IDictionary<string, string> keys;
		private IList<ModuleResult> results;

		public ParsedDocument()
		{
			keys = new Dictionary<string, string>();
			results = new List<ModuleResult>();
		}

		public IDictionary<string, string> Keys
		{
			get { return keys; }
		}

		public IList<ModuleResult> Results
		{
			get { return results; }
		}
	}
}
