package edgarcai.swf{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import edgarcai.BytesAndStr16;
	import edgarcai.outputError;
	
	public class Tag{
		public var headOffset:int;
		public var bodyOffset:int;
		public var bodyLength:int;
		public var type:int;
		
		public function Tag(_type:int=-1){
			type=_type;
		}
		
		public function initByData(data:ByteArray,offset:int):void{
			headOffset=offset;
			var temp:int=data[offset++];
			type=(temp>>>6)|(data[offset++]<<2);
			bodyLength=temp&0x3f;
			if(bodyLength==0x3f){
				bodyLength=data[offset++]|(data[offset++]<<8)|(data[offset++]<<16)|(data[offset++]<<24);
			}
			bodyOffset=offset;
			
			__bodyData=data;
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var bodyData:ByteArray;
			if(__body){
				bodyData=__body.toData(_toDataOptions);
				bodyLength=bodyData.length;
			}else{
				bodyData=new ByteArray();
				if(bodyLength>0){
					bodyData.writeBytes(__bodyData,bodyOffset,bodyLength);
				}
			}
			
			var data:ByteArray=new ByteArray();
			data[0]=type<<6;
			data[1]=type>>>2;
			
			if(
				bodyLength>=0x3f
				||
				type==TagTypes.DefineBits
				||
				type==TagTypes.DefineBitsJPEG2
				||
				type==TagTypes.DefineBitsJPEG3
				||
				type==TagTypes.DefineBitsJPEG4
				||
				type==TagTypes.DefineBitsLossless
				||
				type==TagTypes.DefineBitsLossless2
				||
				type==TagTypes.SoundStreamBlock//某天偶然发现的一些小图片变成短tag后出错(不知道还会不会有其它tag有这种现象)
				//||
				//!test_isShort
			){
				//长tag
				data[0]|=0x3f;
				data[2]=bodyLength;
				data[3]=bodyLength>>8;
				data[4]=bodyLength>>16;
				data[5]=bodyLength>>24;
				data.position=6;
			}else{
				data[0]|=bodyLength;
				data.position=2;
			}
			data.writeBytes(bodyData);
			return data;
		}
		
		private var __bodyData:ByteArray;
		public function getBodyData():ByteArray{
			if(__bodyData){
				return __bodyData;
			}
			throw new Error("__bodyData="+__bodyData);
			return null;
		}
		public function setBodyData(_bodyData:ByteArray):void{
			if(_bodyData){
				if(type<0){
					throw new Error("未设置 type");
				}
				setBody(null);
				__bodyData=_bodyData;
				headOffset=0;
				bodyOffset=0;
				bodyLength=__bodyData.length;
			}else{
				__bodyData=null;
				headOffset=-1;
				bodyOffset=-1;
				bodyLength=-1;
			}
		}
		
		private var __body:*;
		public function getBody(TagBodyClass:Class,_initByDataOptions:Object):*{
			if(__body){
			}else{
				if(__bodyData){
					__body=new TagBodyClass();
					var endOffset:int=bodyOffset+bodyLength;
					var offset:int=__body.initByData(__bodyData,bodyOffset,endOffset,_initByDataOptions);
					if(offset==endOffset){
					}else{
						outputError("type="+type+"，typeName="+TagTypes.typeNameV[type]+"，offset="+offset+"，endOffset="+endOffset);
					}
				}
			}
			return __body;
		}
		public function setBody(_body:*):void{
			if(_body){
				setBodyData(null);
				var typeName:String=getQualifiedClassName(_body).split(/\.|\:/).pop();
				type=TagTypes[typeName];
				if(TagTypes.typeNameV[type]==typeName){
					__body=_body;
				}else{
					throw new Error("未知 typeName："+typeName);
				}
			}else{
				__body=null;
			}
		}
		
		/**
		 * 头两个字节组成的 UI16，例如 DefineButton2 的 id，或 DefineButtonSound 的 ButtonId 
		 * @return 
		 * 
		 */		
		public function get UI16Id():int{
			if(__body){
				return __body["id"];
			}
			if(__bodyData){
				if(bodyLength<2){
					throw new Error("bodyLength="+bodyLength);
				}
				return __bodyData[bodyOffset]|(__bodyData[bodyOffset+1]<<8);
			}
			throw new Error("未处理");
			return -1;
		}
		
		/**
		 * 头两个字节组成的 UI16，例如 DefineButton2 的 id，或 DefineButtonSound 的 ButtonId 
		 * @param id
		 * 
		 */		
		public function set UI16Id(id:int):void{
			if(__body){
				__body["id"]=id;
			}else if(__bodyData){
				if(bodyLength<2){
					throw new Error("bodyLength="+bodyLength);
				}
				__bodyData[bodyOffset]=id;
				__bodyData[bodyOffset+1]=id>>8;
			}else{
				throw new Error("未处理");
			}
		}
		
		/**
		 * 如果给出 src，表示 getPositionOnly 
		 * @param _toXMLOptions
		 * @return 
		 * 
		 */		
		public function toXML(_toXMLOptions:Object):XML{
			if(__body){
				return __body.toXML(TagTypes.typeNameV[type],_toXMLOptions);
			}
			if(__bodyData){
				if(bodyLength){
					var typeName:String=TagTypes.typeNameV[type];
					if(_toXMLOptions&&type<256&&_toXMLOptions.optionV[type]=="仅位置"){
						if(typeName){
							return <{typeName}
								src={_toXMLOptions.src||_toXMLOptions.getSrcFun(__bodyData)}
								offset={bodyOffset}
								length={bodyLength}
								//test_isShort={test_isShort}
							/>
						}
						return <tag
							type={type}
							src={_toXMLOptions.src||_toXMLOptions.getSrcFun(__bodyData)}
							offset={bodyOffset}
							length={bodyLength}
						/>
					}
					if(typeName){
						return <{typeName}
							length={bodyLength}
							value={BytesAndStr16.bytes2str16(__bodyData,bodyOffset,bodyLength)}
						/>
					}
					return <tag
						type={type}
						length={bodyLength}
						value={BytesAndStr16.bytes2str16(__bodyData,bodyOffset,bodyLength)}
					/>
				}
			}
			return <{TagTypes.typeNameV[type]}
			/>;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			var xmlName:String=xml.name().toString();//20110618
			var typeName:String;
			if(TagTypes[xmlName]>-1){
				type=TagTypes[xmlName];
			}else{
				typeName=xml.@typeName.toString();
				if(TagTypes[typeName]>-1){
					type=TagTypes[typeName];
				}else{
					type=int(xml.@type.toString());
				}
			}
			
			
			var classStr:String=xml["@class"].toString();
			if(classStr){
				//可用户自定义 class
				setBody(new (_initByXMLOptions&&_initByXMLOptions.customClasses&&_initByXMLOptions.customClasses[classStr]||getDefinitionByName(classStr))());
				__body.initByXML(xml,_initByXMLOptions);
			}else{
				var valueStr:String=xml.@value.toString();
				if(valueStr){
					setBodyData(BytesAndStr16.str162bytes(valueStr));
				}else{
					var src:String=xml.@src.toString();
					if(src){
						if(_initByXMLOptions){
						}else{
							throw new Error("需要提供 _initByXMLOptions");
						}
						
						var resData:ByteArray=_initByXMLOptions.resData||_initByXMLOptions.getResDataFun(src);
						setBodyData(resData);
						var offsetXML:XML=xml.@offset[0];
						if(offsetXML){
							bodyOffset=int(offsetXML.toString());
						}else{
							bodyOffset=0;//20110928
						}
						var lengthXML:XML=xml.@length[0];
						if(lengthXML){
							bodyLength=int(lengthXML.toString());
						}else{
							bodyLength=resData.length-bodyOffset;//20110928
						}
					}
				}
			}
		}
	}
}
		