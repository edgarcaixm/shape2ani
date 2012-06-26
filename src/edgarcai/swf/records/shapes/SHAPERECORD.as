package edgarcai.swf.records.shapes{
	import flash.utils.ByteArray;
	public class SHAPERECORD{
		
		public var type:String;
		
		public var DeltaX:int;
		public var DeltaY:int;
		
		public var ControlDeltaX:int;
		public var ControlDeltaY:int;
		public var AnchorDeltaX:int;
		public var AnchorDeltaY:int;
		
		public var MoveDeltaXY:Array;
		//public var MoveDeltaX:int;
		//public var MoveDeltaY:int;
		public var FillStyle0:int;//从 1 开始（0 表示没有填充）
		public var FillStyle1:int;//从 1 开始（0 表示没有填充）
		public var LineStyle:int;//从 1 开始（0 表示没有笔触）
		public var FillStyleV:Vector.<FILLSTYLE>;
		public var LineStyleV:Vector.<LINESTYLE>;
		public var LineStyle2V:Vector.<LINESTYLE2>;
		
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			throw new Error("直接在 SHAPEWITHSTYLE 里 initByData");
		}
		public function toData(_toDataOptions:Object):ByteArray{
			throw new Error("直接在 SHAPEWITHSTYLE 里 toData");
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			var xml:XML=<{xmlName} class="edgarcai.swf.records.shapes.SHAPERECORD"
				type={type}
			/>;
			switch(type){
				case ShapeRecordTypes.STRAIGHTEDGERECORD:
					xml.@DeltaX=DeltaX;
					xml.@DeltaY=DeltaY;
					break;
				case ShapeRecordTypes.CURVEDEDGERECORD:
					xml.@ControlDeltaX=ControlDeltaX;
					xml.@ControlDeltaY=ControlDeltaY;
					xml.@AnchorDeltaX=AnchorDeltaX;
					xml.@AnchorDeltaY=AnchorDeltaY;
					break;
				case ShapeRecordTypes.STYLECHANGERECORD:
					if(MoveDeltaXY){
						xml.@MoveDeltaX=MoveDeltaXY[0];
						xml.@MoveDeltaY=MoveDeltaXY[1];
					}
					//if(MoveDeltaX||MoveDeltaY){
					//	xml.@MoveDeltaX=MoveDeltaX;
					//	xml.@MoveDeltaY=MoveDeltaY;
					//}
					if(FillStyle0>-1){
						xml.@FillStyle0=FillStyle0;
					}
					if(FillStyle1>-1){
						xml.@FillStyle1=FillStyle1;
					}
					if(LineStyle>-1){
						xml.@LineStyle=LineStyle;
					}
					if(FillStyleV&&FillStyleV.length){
						var FillStyleListXML:XML=<FillStyleList count={FillStyleV.length}/>
						for each(var FillStyle:FILLSTYLE in FillStyleV){
							FillStyleListXML.appendChild(FillStyle.toXML("FillStyle",_toXMLOptions));
						}
						xml.appendChild(FillStyleListXML);
					}
					if(LineStyle2V&&LineStyle2V.length){
						var LineStyle2ListXML:XML=<LineStyle2List count={LineStyle2V.length}/>
						for each(var LineStyle2:LINESTYLE2 in LineStyle2V){
							LineStyle2ListXML.appendChild(LineStyle2.toXML("LineStyle2",_toXMLOptions));
						}
						xml.appendChild(LineStyle2ListXML);
					}
					if(LineStyleV&&LineStyleV.length){
						var LineStyleListXML:XML=<LineStyleList count={LineStyleV.length}/>
						for each(var LineStyle:LINESTYLE in LineStyleV){
							LineStyleListXML.appendChild(LineStyle.toXML("LineStyle",_toXMLOptions));
						}
						xml.appendChild(LineStyleListXML);
					}
					break;
				case ShapeRecordTypes.ENDSHAPERECORD:
					break;
			}
			return xml;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			
			var i:int;
			
			type=xml.@type.toString();
			switch(type){
				case ShapeRecordTypes.STRAIGHTEDGERECORD:
					DeltaX=int(xml.@DeltaX.toString());
					DeltaY=int(xml.@DeltaY.toString());
					break;
				case ShapeRecordTypes.CURVEDEDGERECORD:
					ControlDeltaX=int(xml.@ControlDeltaX.toString());
					ControlDeltaY=int(xml.@ControlDeltaY.toString());
					AnchorDeltaX=int(xml.@AnchorDeltaX.toString());
					AnchorDeltaY=int(xml.@AnchorDeltaY.toString());
					break;
				case ShapeRecordTypes.STYLECHANGERECORD:
					var MoveDeltaXXML:XML=xml.@MoveDeltaX[0];
					var MoveDeltaYXML:XML=xml.@MoveDeltaY[0];
					if(MoveDeltaXXML&&MoveDeltaYXML){
						MoveDeltaXY=[int(MoveDeltaXXML.toString()),int(MoveDeltaYXML.toString())];
					}else{
						MoveDeltaXY=null;
					}
					var FillStyle0XML:XML=xml.@FillStyle0[0];
					if(FillStyle0XML){
						FillStyle0=int(xml.@FillStyle0.toString());
					}else{
						FillStyle0=-1;
					}
					var FillStyle1XML:XML=xml.@FillStyle1[0];
					if(FillStyle1XML){
						FillStyle1=int(xml.@FillStyle1.toString());
					}else{
						FillStyle1=-1;
					}
					var LineStyleXML:XML=xml.@LineStyle[0];
					if(LineStyleXML){
						LineStyle=int(xml.@LineStyle.toString());
					}else{
						LineStyle=-1;
					}
					
					i=-1;
					FillStyleV=new Vector.<FILLSTYLE>();
					for each(var FillStyleXML:XML in xml.FillStyleList.FillStyle){
					i++;
					FillStyleV[i]=new FILLSTYLE();
					FillStyleV[i].initByXML(FillStyleXML,_initByXMLOptions);
				}
					if(FillStyleV.length){
					}else{
						FillStyleV=null;
					}
					i=-1;
					LineStyle2V=new Vector.<LINESTYLE2>();
					for each(var LineStyle2XML:XML in xml.LineStyle2List.LineStyle2){
					i++;
					LineStyle2V[i]=new LINESTYLE2();
					LineStyle2V[i].initByXML(LineStyle2XML,_initByXMLOptions);
				}
					if(LineStyle2V.length){
					}else{
						LineStyle2V=null;
						LineStyleV=new Vector.<LINESTYLE>();
						for each(LineStyleXML in xml.LineStyleList.LineStyle){
							i++;
							LineStyleV[i]=new LINESTYLE();
							LineStyleV[i].initByXML(LineStyleXML,_initByXMLOptions);
						}
						if(LineStyleV.length){
						}else{
							LineStyleV=null;
						}
					}
					break;
				case ShapeRecordTypes.ENDSHAPERECORD:
					//
					break;
			}
		}
	}
}