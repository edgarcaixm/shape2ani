package edgarcai.swf.records.shapes{
	import flash.utils.ByteArray;
	
	import edgarcai.BytesAndStr16;
	public class LINESTYLE2{
		public var Width:int;							//UI16
		public var StartCapStyle:int;
		public var JoinStyle:int;
		public var NoHScaleFlag:Boolean;
		public var NoVScaleFlag:Boolean;
		public var PixelHintingFlag:Boolean;
		public var NoClose:Boolean;
		public var EndCapStyle:int;
		public var MiterLimitFactor:int;				//UI16
		public var Color:uint;							//RGBA
		public var FillType:FILLSTYLE;
		//
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			Width=data[offset++]|(data[offset++]<<8);
			var flags:int=data[offset++];
			StartCapStyle=(flags<<24)>>>30;					//11000000
			JoinStyle=(flags<<26)>>>30;						//00110000
			NoHScaleFlag=((flags&0x04)?true:false);		//00000100
			NoVScaleFlag=((flags&0x02)?true:false);		//00000010
			PixelHintingFlag=((flags&0x01)?true:false);	//00000001
			var flags2:int=data[offset++];
			//Reserved=(flags2<<24)>>>27;					//11111000
			NoClose=((flags2&0x04)?true:false);			//00000100
			EndCapStyle=flags2&0x03;						//00000011
			
			if(JoinStyle==2){
				MiterLimitFactor=data[offset++]|(data[offset++]<<8);
			}
			
			if(flags&0x08){//HasFillFlag				//00001000
				FillType=new FILLSTYLE();
				offset=FillType.initByData(data,offset,endOffset,_initByDataOptions);
			}else{
				Color=(data[offset++]<<16)|(data[offset++]<<8)|data[offset++]|(data[offset++]<<24);
			}
			
			return offset;
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			
			data[0]=Width;
			data[1]=Width>>8;
			
			var flags:int=0;
			flags|=StartCapStyle<<6;					//11000000
			flags|=JoinStyle<<4;						//00110000
			if(FillType){
				flags|=0x08;							//00001000
			}	
			if(NoHScaleFlag){
				flags|=0x04;							//00000100
			}
			if(NoVScaleFlag){
				flags|=0x02;							//00000010
			}
			if(PixelHintingFlag){
				flags|=0x01;							//00000001
			}
			data[2]=flags;
			
			var flags2:int=0;
			//flags2|=Reserved<<3;						//11111000
			if(NoClose){
				flags2|=0x04;							//00000100
			}
			flags2|=EndCapStyle;							//00000011
			data[3]=flags2;
			
			var offset:int=4;
			
			if(JoinStyle==2){
				data[offset++]=MiterLimitFactor;
				data[offset++]=MiterLimitFactor>>8;
			}
			
			if(FillType){
				data.position=offset;
				data.writeBytes(FillType.toData(_toDataOptions));
			}else{
				data[offset++]=Color>>16;
				data[offset++]=Color>>8;
				data[offset++]=Color;
				data[offset++]=Color>>24;
			}
			return data;
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			var xml:XML=<{xmlName} class="edgarcai.swf.records.shapes.LINESTYLE2"
				Width={Width}
			StartCapStyle={StartCapStyle}
			JoinStyle={JoinStyle}
			NoHScaleFlag={NoHScaleFlag}
			NoVScaleFlag={NoVScaleFlag}
			PixelHintingFlag={PixelHintingFlag}
			NoClose={NoClose}
			EndCapStyle={EndCapStyle}
			/>;
			if(JoinStyle==2){
				xml.@MiterLimitFactor=MiterLimitFactor;
			}
			if(FillType){
				xml.appendChild(FillType.toXML("FillType",_toXMLOptions));
			}else{
				xml.@Color="0x"+BytesAndStr16._16V[(Color>>24)&0xff]+BytesAndStr16._16V[(Color>>16)&0xff]+BytesAndStr16._16V[(Color>>8)&0xff]+BytesAndStr16._16V[Color&0xff];
			}
			return xml;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			Width=int(xml.@Width.toString());
			StartCapStyle=int(xml.@StartCapStyle.toString());
			JoinStyle=int(xml.@JoinStyle.toString());
			NoHScaleFlag=(xml.@NoHScaleFlag.toString()=="true");
			NoVScaleFlag=(xml.@NoVScaleFlag.toString()=="true");
			PixelHintingFlag=(xml.@PixelHintingFlag.toString()=="true");
			NoClose=(xml.@NoClose.toString()=="true");
			EndCapStyle=int(xml.@EndCapStyle.toString());
			if(JoinStyle==2){
				MiterLimitFactor=int(xml.@MiterLimitFactor.toString());
			}
			var FillTypeXML:XML=xml.FillType[0];
			if(FillTypeXML){
				FillType=new FILLSTYLE();
				FillType.initByXML(FillTypeXML,_initByXMLOptions);
			}else{
				Color=uint(xml.@Color.toString());
			}
		}
	}
}
