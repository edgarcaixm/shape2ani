//A line style has two parts, an unsigned 16-bit integer indicating the width of a line in twips,
//and a color. Here is the file description:
//LINESTYLE
//Field 			Type 					Comment
//Width 			UI16 					Width of line in twips
//Color 			RGB (Shape1 or Shape2)
//					RGBA (Shape3)			Color value including alpha channel information for Shape3
//The color in this case is a 24-bit RGB, but if we were doing a DefineShape3, it would be a 32-
//bit RGBA where alpha is the opacity of the color.
package edgarcai.swf.records.shapes{
	import edgarcai.BytesAndStr16;
	import flash.utils.ByteArray;
	public class LINESTYLE{
		public var Width:int;							//UI16
		public var Color:uint;
		//
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			Width=data[offset++]|(data[offset++]<<8);
			if(_initByDataOptions&&_initByDataOptions.ColorUseRGBA){//20110813
				Color=(data[offset++]<<16)|(data[offset++]<<8)|data[offset++]|(data[offset++]<<24);
			}else{
				Color=(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
			}
			return offset;
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			data[0]=Width;
			data[1]=Width>>8;
			if(_toDataOptions&&_toDataOptions.ColorUseRGBA){//20110813
				data[2]=Color>>16;
				data[3]=Color>>8;
				data[4]=Color;
				data[5]=Color>>24;
			}else{
				data[2]=Color>>16;
				data[3]=Color>>8;
				data[4]=Color;
			}
			return data;
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			var xml:XML=<{xmlName} class="edgarcai.swf.records.shapes.LINESTYLE"
				Width={Width}
			/>;
			if(_toXMLOptions&&_toXMLOptions.ColorUseRGBA){//20110813
				xml.@Color="0x"+BytesAndStr16._16V[(Color>>24)&0xff]+BytesAndStr16._16V[(Color>>16)&0xff]+BytesAndStr16._16V[(Color>>8)&0xff]+BytesAndStr16._16V[Color&0xff];
			}else{
				xml.@Color="0x"+BytesAndStr16._16V[(Color>>16)&0xff]+BytesAndStr16._16V[(Color>>8)&0xff]+BytesAndStr16._16V[Color&0xff];
			}
			return xml;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			Width=int(xml.@Width.toString());
			Color=uint(xml.@Color.toString());
		}
	}
}
