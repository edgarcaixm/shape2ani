package edgarcai.swf.records.shapes{
	import flash.utils.ByteArray;
	
	import edgarcai.BytesAndStr16;
	public class GRADIENT{
		public var SpreadMode:int;
		public var InterpolationMode:int;
		public var RatioV:Vector.<int>;
		public var ColorV:Vector.<uint>;
		//
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			var flags:int=data[offset++];
			SpreadMode=(flags<<24)>>>30;				//11000000
			InterpolationMode=(flags<<26)>>>30;			//00110000
			var NumGradients:int=flags&0x0f;			//00001111
			RatioV=new Vector.<int>();
			ColorV=new Vector.<uint>();
			for(var i:int=0;i<NumGradients;i++){
				RatioV[i]=data[offset++];
				if(_initByDataOptions&&_initByDataOptions.ColorUseRGBA){//20110813
					ColorV[i]=(data[offset++]<<16)|(data[offset++]<<8)|data[offset++]|(data[offset++]<<24);
				}else{
					ColorV[i]=(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
				}
			}
			return offset;
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			var flags:int=0;
			flags|=SpreadMode<<6;						//11000000
			flags|=InterpolationMode<<4;				//00110000
			flags|=RatioV.length;//NumGradients;		//00001111
			data[0]=flags;
			
			var offset:int=1;
			var i:int=-1;
			for each(var Color:uint in ColorV){
				i++;
				data[offset++]=RatioV[i];
				if(_toDataOptions&&_toDataOptions.ColorUseRGBA){//20110813
					data[offset++]=Color>>16;
					data[offset++]=Color>>8;
					data[offset++]=Color;
					data[offset++]=Color>>24;
				}else{
					data[offset++]=Color>>16;
					data[offset++]=Color>>8;
					data[offset++]=Color;
				}
			}
			return data;
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			var xml:XML=<{xmlName} class="edgarcai.swf.records.shapes.GRADIENT"
				SpreadMode={SpreadMode}
			InterpolationMode={InterpolationMode}
			/>;
			if(ColorV.length){
				var RatioAndColorListXML:XML=<RatioAndColorList count={ColorV.length}/>
				var i:int=-1;
				for each(var Color:uint in ColorV){
					i++;
					RatioAndColorListXML.appendChild(<Ratio value={RatioV[i]}/>);
					if(_toXMLOptions&&_toXMLOptions.ColorUseRGBA){
						RatioAndColorListXML.appendChild(<Color value={"0x"+BytesAndStr16._16V[(Color>>24)&0xff]+BytesAndStr16._16V[(Color>>16)&0xff]+BytesAndStr16._16V[(Color>>8)&0xff]+BytesAndStr16._16V[Color&0xff]}/>);
					}else{
						RatioAndColorListXML.appendChild(<Color value={"0x"+BytesAndStr16._16V[(Color>>16)&0xff]+BytesAndStr16._16V[(Color>>8)&0xff]+BytesAndStr16._16V[Color&0xff]}/>);
					}
				}
				xml.appendChild(RatioAndColorListXML);
			}
			return xml;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			SpreadMode=int(xml.@SpreadMode.toString());
			InterpolationMode=int(xml.@InterpolationMode.toString());
			RatioV=new Vector.<int>();
			ColorV=new Vector.<uint>();
			var i:int=-1;
			var RatioXMLList:XMLList=xml.RatioAndColorList.Ratio;
			for each(var ColorXML:XML in xml.RatioAndColorList.Color){
				i++;
				RatioV[i]=int(RatioXMLList[i].@value.toString());
				ColorV[i]=uint(ColorXML.@value.toString());
			}
		}
	}
}