//TAG 1 ~ 5000 for C# NetMsg
//TAG 5001 ~ MAX for LUA NetMsg

// source: netmsgCS

using System;
using Sproto;
using System.Collections.Generic;

namespace SprotoType { 
	public class SYSTEM_CS_TESTMSG {
	
		public class request : SprotoTypeBase {
			private static int max_field_count = 2;
			
			
			private Int64 _servertime; // tag 0
			public Int64 servertime {
				get { return _servertime; }
				set { base.has_field.set_field (0, true); _servertime = value; }
			}
			public bool HasServertime {
				get { return base.has_field.has_field (0); }
			}

			private string _teststr; // tag 1
			public string teststr {
				get { return _teststr; }
				set { base.has_field.set_field (1, true); _teststr = value; }
			}
			public bool HasTeststr {
				get { return base.has_field.has_field (1); }
			}

			public request () : base(max_field_count) {}

			public request (byte[] buffer) : base(max_field_count, buffer) {
				this.decode ();
			}

			protected override void decode () {
				int tag = -1;
				while (-1 != (tag = base.deserialize.read_tag ())) {
					switch (tag) {
					case 0:
						this.servertime = base.deserialize.read_integer ();
						break;
					case 1:
						this.teststr = base.deserialize.read_string ();
						break;
					default:
						base.deserialize.read_unknow_data ();
						break;
					}
				}
			}

			public override int encode (SprotoStream stream) {
				base.serialize.open (stream);

				if (base.has_field.has_field (0)) {
					base.serialize.write_integer (this.servertime, 0);
				}

				if (base.has_field.has_field (1)) {
					base.serialize.write_string (this.teststr, 1);
				}

				return base.serialize.close ();
			}
		}


	}


	public class SYSTEM_SC_TESTMSG {
	
		public class request : SprotoTypeBase {
			private static int max_field_count = 2;
			
			
			private Int64 _servertime; // tag 0
			public Int64 servertime {
				get { return _servertime; }
				set { base.has_field.set_field (0, true); _servertime = value; }
			}
			public bool HasServertime {
				get { return base.has_field.has_field (0); }
			}

			private string _teststr; // tag 1
			public string teststr {
				get { return _teststr; }
				set { base.has_field.set_field (1, true); _teststr = value; }
			}
			public bool HasTeststr {
				get { return base.has_field.has_field (1); }
			}

			public request () : base(max_field_count) {}

			public request (byte[] buffer) : base(max_field_count, buffer) {
				this.decode ();
			}

			protected override void decode () {
				int tag = -1;
				while (-1 != (tag = base.deserialize.read_tag ())) {
					switch (tag) {
					case 0:
						this.servertime = base.deserialize.read_integer ();
						break;
					case 1:
						this.teststr = base.deserialize.read_string ();
						break;
					default:
						base.deserialize.read_unknow_data ();
						break;
					}
				}
			}

			public override int encode (SprotoStream stream) {
				base.serialize.open (stream);

				if (base.has_field.has_field (0)) {
					base.serialize.write_integer (this.servertime, 0);
				}

				if (base.has_field.has_field (1)) {
					base.serialize.write_string (this.teststr, 1);
				}

				return base.serialize.close ();
			}
		}


	}


	public class package : SprotoTypeBase {
		private static int max_field_count = 2;
		
		
		private Int64 _type; // tag 0
		public Int64 type {
			get { return _type; }
			set { base.has_field.set_field (0, true); _type = value; }
		}
		public bool HasType {
			get { return base.has_field.has_field (0); }
		}

		private Int64 _session; // tag 1
		public Int64 session {
			get { return _session; }
			set { base.has_field.set_field (1, true); _session = value; }
		}
		public bool HasSession {
			get { return base.has_field.has_field (1); }
		}

		public package () : base(max_field_count) {}

		public package (byte[] buffer) : base(max_field_count, buffer) {
			this.decode ();
		}

		protected override void decode () {
			int tag = -1;
			while (-1 != (tag = base.deserialize.read_tag ())) {
				switch (tag) {
				case 0:
					this.type = base.deserialize.read_integer ();
					break;
				case 1:
					this.session = base.deserialize.read_integer ();
					break;
				default:
					base.deserialize.read_unknow_data ();
					break;
				}
			}
		}

		public override int encode (SprotoStream stream) {
			base.serialize.open (stream);

			if (base.has_field.has_field (0)) {
				base.serialize.write_integer (this.type, 0);
			}

			if (base.has_field.has_field (1)) {
				base.serialize.write_integer (this.session, 1);
			}

			return base.serialize.close ();
		}
	}


}


public class Protocol : ProtocolBase {
	public static  Protocol Instance = new Protocol();
	private Protocol() {
		Protocol.SetProtocol<SprotoType.SYSTEM_CS_TESTMSG> (1);
		Protocol.SetRequest<SprotoType.SYSTEM_CS_TESTMSG.request> (1);

		Protocol.SetProtocol<SprotoType.SYSTEM_SC_TESTMSG> (2);
		Protocol.SetRequest<SprotoType.SYSTEM_SC_TESTMSG.request> (2);

	}

}