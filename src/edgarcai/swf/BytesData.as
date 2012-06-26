package edgarcai.swf{
	
	import flash.utils.ByteArray;
	
	import edgarcai.BytesAndStr16;
	
	public class BytesData{
		public var ownData:ByteArray;
		public var dataOffset:int;
		public var dataLength:int;
		public function BytesData(){
		}
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			ownData=data;
			dataOffset=offset;
			dataLength=endOffset-offset;
			return endOffset;
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			if(dataLength>0){
				data.writeBytes(ownData,dataOffset,dataLength);
			}
			return data;
		}
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			if(dataLength>0){
				if(_toXMLOptions&&_toXMLOptions.BytesDataToXMLOption=="数据块（仅位置）"){
					return <{xmlName} class="edgarcai.swf.BytesData"
						src={_toXMLOptions.src||_toXMLOptions.getSrcFun(ownData)}
					offset={dataOffset}
					length={dataLength}
					/>;
				}
				return <{xmlName} class="edgarcai.swf.BytesData"
					length={dataLength}
				value={BytesAndStr16.bytes2str16(ownData,dataOffset,dataLength)}
				/>;
			}
			return <{xmlName} class="edgarcai.swf.BytesData"/>;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			var value:String=xml.@value.toString();
			if(value){
				var data:ByteArray=BytesAndStr16.str162bytes(value);
				initByData(data,0,data.length,null);
			}else{
				var src:String=xml.@src.toString();
				if(src){
					if(_initByXMLOptions){
					}else{
						throw new Error("需要提供 _initByXMLOptions");
					}
					
					var offset:int,endOffset:int;
					var resData:ByteArray=_initByXMLOptions.resData||_initByXMLOptions.getResDataFun(src);
					var offsetXML:XML=xml.@offset[0];
					if(offsetXML){
						offset=int(offsetXML.toString());
					}else{
						offset=0;//20110928
					}
					var lengthXML:XML=xml.@length[0];
					if(lengthXML){
						endOffset=offset+int(lengthXML.toString());
					}else{
						endOffset=resData.length;//20110928
					}
					initByData(resData,offset,endOffset,null);
				}else{
					initByData(new ByteArray(),0,0,null);
				}
			}
		}
	}
}

