package edgarcai.swf.tagBodys{
	
	import flash.utils.ByteArray;
	import edgarcai.swf.records.RECT;
	import edgarcai.swf.records.shapes.SHAPEWITHSTYLE;
	
	public class DefineShape{
		
		public var id:int;//UI16
		public var ShapeBounds:RECT;
		public var Shapes:SHAPEWITHSTYLE;
		
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			
			if(_initByDataOptions){
			}else{
				_initByDataOptions=new Object();
			}
			_initByDataOptions.ColorUseRGBA=false;//20110813
			_initByDataOptions.LineStyleUseLINESTYLE2=false;//20110814
			
			id=data[offset++]|(data[offset++]<<8);
			
			ShapeBounds=new RECT();
			offset=ShapeBounds.initByData(data,offset,endOffset,_initByDataOptions);
			
			Shapes=new SHAPEWITHSTYLE();
			return Shapes.initByData(data,offset,endOffset,_initByDataOptions);
			
		}
		public function toData(_toDataOptions:Object):ByteArray{
			
			if(_toDataOptions){
			}else{
				_toDataOptions=new Object();
			}
			_toDataOptions.ColorUseRGBA=false;//20110813
			
			var data:ByteArray=new ByteArray();
			
			data[0]=id;
			data[1]=id>>8;
			
			data.position=2;
			data.writeBytes(ShapeBounds.toData(_toDataOptions));
			
			data.writeBytes(Shapes.toData(_toDataOptions));
			
			return data;
			
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			
			if(_toXMLOptions){
			}else{
				_toXMLOptions=new Object();
			}
			_toXMLOptions.ColorUseRGBA=false;//20110813
			
			var xml:XML=<{xmlName} class="edgarcai.swf.tagBodys.DefineShape"
				id={id}
			/>;
			
			xml.appendChild(ShapeBounds.toXML("ShapeBounds",_toXMLOptions));
			
			xml.appendChild(Shapes.toXML("Shapes",_toXMLOptions));
			
			return xml;
			
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			
			id=int(xml.@id.toString());
			
			ShapeBounds=new RECT();
			ShapeBounds.initByXML(xml.ShapeBounds[0],_initByXMLOptions);
			
			Shapes=new SHAPEWITHSTYLE();
			Shapes.initByXML(xml.Shapes[0],_initByXMLOptions);
			
		}
	}
}