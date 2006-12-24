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
