/* vim: set noet tw=80 sts=8 sw=8 ts=8 nolist: */

using Repodoc;

class OurParserTask : ParserTask {
	public OurParserTask(System.IO.TextReader t) :
		base(t)
	{
	}

	public override void on_parse_all_pre()
	{
	}

	public override void on_parse_document_pre()
	{
	}

	public override void on_parse_document_kv(string k, string v)
	{
		System.Console.WriteLine("'{0}' = '{1}'", k, v);
	}

	public override void on_parse_module_all_pre()
	{
	}

	public override void on_parse_module_pre()
	{
	}

	public override void on_parse_module_name(string name)
	{
		System.Console.Write("Doing module '{0}'", name);
	}

	public override void on_parse_module_ok()
	{
		System.Console.Write(" ... ok ... ");
	}

	public override void on_parse_module_warning()
	{
		System.Console.Write(" ... warning ... ");
	}

	public override void on_parse_module_critical()
	{
		System.Console.Write(" ... critical ... ");
	}

	public override void on_parse_module_output(string output)
	{
	}

	public override void on_parse_module_post()
	{
		System.Console.WriteLine("done");
	}

	public override void on_parse_module_all_post()
	{
	}

	public override void on_parse_document_post()
	{
	}

	public override void on_parse_all_post()
	{
	}
}

class repo_front {
	static void Main(string[] args)
	{
		ParserTask r = new OurParserTask(System.Console.In);
		r.parse();
	}
}
