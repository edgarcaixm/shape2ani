package edgarcai.swf.records.shapes{
	import flash.utils.ByteArray;
	
	import edgarcai.swf.BytesData;
	import edgarcai.swf.records.shapes.FILLSTYLE;
	
	public class SHAPEWITHSTYLE{
		public var FillStyleV:Vector.<FILLSTYLE>;
		public var LineStyleV:Vector.<LINESTYLE>;
		public var LineStyle2V:Vector.<LINESTYLE2>;
		public var ShapeRecordV:Vector.<SHAPERECORD>;
		
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			
			var i:int;
			
			var FillStyleCount:int=data[offset++];
			if(FillStyleCount==0xff){
				FillStyleCount=data[offset++]|(data[offset++]<<8);
			}
			if(FillStyleCount){
				FillStyleV=new Vector.<FILLSTYLE>();
				for(i=0;i<FillStyleCount;i++){
					FillStyleV[i]=new FILLSTYLE();
					offset=FillStyleV[i].initByData(data,offset,endOffset,_initByDataOptions);
				}
			}else{
				FillStyleV=null;
			}
			var LineStyleCount:int=data[offset++];
			if(LineStyleCount==0xff){
				LineStyleCount=data[offset++]|(data[offset++]<<8);
			}
			if(LineStyleCount){
				if(_initByDataOptions.LineStyleUseLINESTYLE2){
					LineStyle2V=new Vector.<LINESTYLE2>();
					for(i=0;i<LineStyleCount;i++){
						LineStyle2V[i]=new LINESTYLE2();
						offset=LineStyle2V[i].initByData(data,offset,endOffset,_initByDataOptions);
					}
					LineStyleV=null;
				}else{
					LineStyleV=new Vector.<LINESTYLE>();
					for(i=0;i<LineStyleCount;i++){
						LineStyleV[i]=new LINESTYLE();
						offset=LineStyleV[i].initByData(data,offset,endOffset,_initByDataOptions);
					}
					LineStyle2V=null;
				}
			}else{
				LineStyleV=null;
				LineStyle2V=null;
			}
			var flags:int=data[offset++];
			var currNumFillBits:int=(flags<<24)>>>28;				//11110000
			var currNumLineBits:int=flags&0x0f;						//00001111
			
			//trace("currNumFillBits="+currNumFillBits);
			//trace("currNumLineBits="+currNumLineBits);
			
			//import edgarcai.BytesAndStr16;
			//trace(BytesAndStr16.bytes2str16(data,offset,20));
			
			ShapeRecordV=new Vector.<SHAPERECORD>();
			
			//var currFillStyleV:Vector.<FILLSTYLE>=FillStyleV;
			//var currLineStyleV:Vector.<LINESTYLE>=LineStyleV;
			//var currLineStyle2V:Vector.<LINESTYLE2>=LineStyle2V;
			
			i=-1;
			var bGroupValue:int=(data[offset++]<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
			var bGroupBitsOffset:int=0;
			
			var bGroupRshiftBitsOffset:int;
			var bGroupNegMask:int;
			var bGroupNeg:int;
			
			while(true){
				i++;
				
				var ShapeRecord:SHAPERECORD=new SHAPERECORD();
				ShapeRecordV[i]=ShapeRecord;
				
				var first6Bits:int=(bGroupValue<<bGroupBitsOffset)>>>26;
				bGroupBitsOffset+=6;
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
				
				if(first6Bits){
					var NumBits:int;
					switch(first6Bits&0x30){
						case 0x30://110000
							ShapeRecord.type=ShapeRecordTypes.STRAIGHTEDGERECORD;
							
							NumBits=(first6Bits&0x0f)+2;
							bGroupRshiftBitsOffset=32-NumBits;
							bGroupNegMask=1<<(NumBits-1);
							bGroupNeg=0xffffffff<<NumBits;
							
							if((bGroupValue<<bGroupBitsOffset)>>>31){//GeneralLineFlag
								
								bGroupBitsOffset++;
								
								ShapeRecord.DeltaX=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
								if(ShapeRecord.DeltaX&bGroupNegMask){ShapeRecord.DeltaX|=bGroupNeg;}//最高位为1,表示负数
								bGroupBitsOffset+=NumBits;
								
								//从 data 读取足够多的位数以备下面使用:
								if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
								
								ShapeRecord.DeltaY=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
								if(ShapeRecord.DeltaY&bGroupNegMask){ShapeRecord.DeltaY|=bGroupNeg;}//最高位为1,表示负数
								bGroupBitsOffset+=NumBits;
								
							}else{
								
								bGroupBitsOffset++;
								
								if((bGroupValue<<bGroupBitsOffset)>>>31){//VertLineFlag
									
									bGroupBitsOffset++;
									
									ShapeRecord.DeltaY=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
									if(ShapeRecord.DeltaY&bGroupNegMask){ShapeRecord.DeltaY|=bGroupNeg;}//最高位为1,表示负数
									bGroupBitsOffset+=NumBits;
									
								}else{
									
									bGroupBitsOffset++;
									
									ShapeRecord.DeltaX=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
									if(ShapeRecord.DeltaX&bGroupNegMask){ShapeRecord.DeltaX|=bGroupNeg;}//最高位为1,表示负数
									bGroupBitsOffset+=NumBits;
									
								}
							}
							
							break;
						case 0x20://100000
							ShapeRecord.type=ShapeRecordTypes.CURVEDEDGERECORD;
							
							NumBits=(first6Bits&0x0f)+2;
							bGroupRshiftBitsOffset=32-NumBits;
							bGroupNegMask=1<<(NumBits-1);
							bGroupNeg=0xffffffff<<NumBits;
							
							ShapeRecord.ControlDeltaX=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
							if(ShapeRecord.ControlDeltaX&bGroupNegMask){ShapeRecord.ControlDeltaX|=bGroupNeg;}//最高位为1,表示负数
							bGroupBitsOffset+=NumBits;
							
							//从 data 读取足够多的位数以备下面使用:
							if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
							
							ShapeRecord.ControlDeltaY=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
							if(ShapeRecord.ControlDeltaY&bGroupNegMask){ShapeRecord.ControlDeltaY|=bGroupNeg;}//最高位为1,表示负数
							bGroupBitsOffset+=NumBits;
							
							//从 data 读取足够多的位数以备下面使用:
							if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
							
							ShapeRecord.AnchorDeltaX=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
							if(ShapeRecord.AnchorDeltaX&bGroupNegMask){ShapeRecord.AnchorDeltaX|=bGroupNeg;}//最高位为1,表示负数
							bGroupBitsOffset+=NumBits;
							
							//从 data 读取足够多的位数以备下面使用:
							if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
							
							ShapeRecord.AnchorDeltaY=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
							if(ShapeRecord.AnchorDeltaY&bGroupNegMask){ShapeRecord.AnchorDeltaY|=bGroupNeg;}//最高位为1,表示负数
							bGroupBitsOffset+=NumBits;
							
							break;
						default:
							ShapeRecord.type=ShapeRecordTypes.STYLECHANGERECORD;
							
							//import edgarcai.BytesAndStr2;
							//trace("first6Bits="+BytesAndStr2._2V[first6Bits]);
							
							if(first6Bits&0x01){//StateMoveTo								//000001
								var MoveBits:int=(bGroupValue<<bGroupBitsOffset)>>>27;
								bGroupBitsOffset+=5;
								
								//从 data 读取足够多的位数以备下面使用:
								if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
								
								if(MoveBits){
									bGroupRshiftBitsOffset=32-MoveBits;
									bGroupNegMask=1<<(MoveBits-1);
									bGroupNeg=0xffffffff<<MoveBits;
									//trace("bGroupNegMask="+bGroupNegMask.toString(2));
									//trace("bGroupNeg="+bGroupNeg.toString(2));
									var MoveDeltaX:int=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
									//trace("styleChangeRecord.MoveDeltaX="+styleChangeRecord.MoveDeltaX);
									if(MoveDeltaX&bGroupNegMask){MoveDeltaX|=bGroupNeg;}//最高位为1,表示负数
									bGroupBitsOffset+=MoveBits;
									
									//trace("styleChangeRecord.MoveDeltaX="+styleChangeRecord.MoveDeltaX);
									
									//从 data 读取足够多的位数以备下面使用:
									if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
									
									var MoveDeltaY:int=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
									//trace("styleChangeRecord.MoveDeltaY="+styleChangeRecord.MoveDeltaY);
									if(MoveDeltaY&bGroupNegMask){MoveDeltaY|=bGroupNeg;}//最高位为1,表示负数
									bGroupBitsOffset+=MoveBits;
									
									ShapeRecord.MoveDeltaXY=[MoveDeltaX,MoveDeltaY];
									//ShapeRecord.MoveDeltaX=MoveDeltaX;
									//ShapeRecord.MoveDeltaY=MoveDeltaY;
									
									//从 data 读取足够多的位数以备下面使用:
									if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
									
								}else{
									ShapeRecord.MoveDeltaXY=[0,0];
									//ShapeRecord.MoveDeltaX=0;
									//ShapeRecord.MoveDeltaY=0;
								}
							}else{
								ShapeRecord.MoveDeltaXY=null;
								//ShapeRecord.MoveDeltaX=0;
								//ShapeRecord.MoveDeltaY=0;
							}
							if(first6Bits&0x02){//StateFillStyle0						//000010
								if(currNumFillBits){
									ShapeRecord.FillStyle0=(bGroupValue<<bGroupBitsOffset)>>>(32-currNumFillBits);
									bGroupBitsOffset+=currNumFillBits;
									
									//从 data 读取足够多的位数以备下面使用:
									if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
									
								}else{
									ShapeRecord.FillStyle0=0;
								}
							}else{
								ShapeRecord.FillStyle0=-1;
							}
							if(first6Bits&0x04){//StateFillStyle1						//000100
								if(currNumFillBits){
									ShapeRecord.FillStyle1=(bGroupValue<<bGroupBitsOffset)>>>(32-currNumFillBits);
									bGroupBitsOffset+=currNumFillBits;
									
									//从 data 读取足够多的位数以备下面使用:
									if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
									
								}else{
									ShapeRecord.FillStyle1=0;
								}
							}else{
								ShapeRecord.FillStyle1=-1;
							}
							
							if(first6Bits&0x08){//StateLineStyle						//001000
								if(currNumLineBits){
									ShapeRecord.LineStyle=(bGroupValue<<bGroupBitsOffset)>>>(32-currNumLineBits);
									bGroupBitsOffset+=currNumLineBits;
									
									//从 data 读取足够多的位数以备下面使用:
									//if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
									
								}else{
									ShapeRecord.LineStyle=0;
								}
							}else{
								ShapeRecord.LineStyle=-1;
							}
							
							if(first6Bits&0x10){//StateNewStyles							//010000
								offset-=int(4-bGroupBitsOffset/8);
								
								//3. Replace the current fill and line style arrays with a new set of styles.
								var currFillStyleCount:int=data[offset++];
								if(currFillStyleCount==0xff){
									currFillStyleCount=data[offset++]|(data[offset++]<<8);
								}
								if(currFillStyleCount){
									ShapeRecord.FillStyleV=new Vector.<FILLSTYLE>();
									var currStyleI:int;
									for(currStyleI=0;currStyleI<currFillStyleCount;currStyleI++){
										ShapeRecord.FillStyleV[currStyleI]=new FILLSTYLE();
										offset=ShapeRecord.FillStyleV[currStyleI].initByData(data,offset,endOffset,_initByDataOptions);
									}
								}else{
									ShapeRecord.FillStyleV=null;
								}
								var currLineStyleCount:int=data[offset++];
								if(currLineStyleCount==0xff){
									currLineStyleCount=data[offset++]|(data[offset++]<<8);
								}
								if(currLineStyleCount){
									if(_initByDataOptions.LineStyleUseLINESTYLE2){
										ShapeRecord.LineStyle2V=new Vector.<LINESTYLE2>();
										for(currStyleI=0;currStyleI<currLineStyleCount;currStyleI++){
											ShapeRecord.LineStyle2V[currStyleI]=new LINESTYLE2();
											offset=ShapeRecord.LineStyle2V[currStyleI].initByData(data,offset,endOffset,_initByDataOptions);
										}
										ShapeRecord.LineStyleV=null;
									}else{
										ShapeRecord.LineStyleV=new Vector.<LINESTYLE>();
										for(currStyleI=0;currStyleI<currLineStyleCount;currStyleI++){
											ShapeRecord.LineStyleV[currStyleI]=new LINESTYLE();
											offset=ShapeRecord.LineStyleV[currStyleI].initByData(data,offset,endOffset,_initByDataOptions);
										}
										ShapeRecord.LineStyle2V=null;
									}
								}else{
									ShapeRecord.LineStyleV=null;
									ShapeRecord.LineStyle2V=null;
								}
								flags=data[offset++];
								currNumFillBits=(flags<<24)>>>28;				//11110000
								currNumLineBits=flags&0x0f;						//00001111
								
								bGroupValue=(data[offset++]<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
								bGroupBitsOffset=0;
							}else{
								ShapeRecord.FillStyleV=null;
								ShapeRecord.LineStyleV=null;
								ShapeRecord.LineStyle2V=null;
							}
							break;
					}
				}else{
					ShapeRecord.type=ShapeRecordTypes.ENDSHAPERECORD;
					break;
				}
				
				//trace("ShapeRecord.type="+ShapeRecord.type);
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
			}
			return offset-int(4-bGroupBitsOffset/8);
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			if(FillStyleV){
				var FillStyleCount:int=FillStyleV.length;
				var offset:int;
				if(FillStyleCount<0xff){
					data[0]=FillStyleCount;
					offset=1;
				}else{
					data[0]=0xff;
					data[1]=FillStyleCount;
					data[2]=FillStyleCount>>8;
					offset=3;
				}
				data.position=offset;
				for each(var FillStyle:FILLSTYLE in FillStyleV){
					data.writeBytes(FillStyle.toData(_toDataOptions));
				}
				offset=data.length;
			}else{
				data[0]=0;
				offset=1;
			}
			if(LineStyle2V||LineStyleV){
				var LineStyleCount:int;
				if(LineStyle2V){
					LineStyleCount=LineStyle2V.length;
				}else{
					LineStyleCount=LineStyleV.length;
				}
				if(LineStyleCount<0xff){
					data[offset++]=LineStyleCount;
				}else{
					data[offset++]=0xff;
					data[offset++]=LineStyleCount;
					data[offset++]=LineStyleCount>>8;
				}
				data.position=offset;
				if(LineStyle2V){
					for each(var LineStyle2:LINESTYLE2 in LineStyle2V){
						data.writeBytes(LineStyle2.toData(_toDataOptions));
					}
				}else{
					for each(var LineStyle:LINESTYLE in LineStyleV){
						data.writeBytes(LineStyle.toData(_toDataOptions));
					}
				}
				offset=data.length;
			}else{
				data[offset++]=0;
			}
			
			
			var currNumFillBits:int;
			var currNumLineBits:int;
			
			//计算所需最小位数:
			var calNumBitsShapeRecord:SHAPERECORD;
			var FillStyleBGroupMixNum:int=0;
			var LineStyleBGroupMixNum:int=0;
			
			for each(calNumBitsShapeRecord in ShapeRecordV){
				if(calNumBitsShapeRecord.type==ShapeRecordTypes.STYLECHANGERECORD){
					if(calNumBitsShapeRecord.FillStyleV||calNumBitsShapeRecord.LineStyle2V||calNumBitsShapeRecord.LineStyleV){
						break;
					}
					if(calNumBitsShapeRecord.FillStyle0>-1){
						FillStyleBGroupMixNum|=calNumBitsShapeRecord.FillStyle0;
					}
					if(calNumBitsShapeRecord.FillStyle1>-1){
						FillStyleBGroupMixNum|=calNumBitsShapeRecord.FillStyle1;
					}
					if(calNumBitsShapeRecord.LineStyle>-1){
						LineStyleBGroupMixNum|=calNumBitsShapeRecord.LineStyle;
					}
				}
			}
			if(FillStyleBGroupMixNum>>>16){if(FillStyleBGroupMixNum>>>24){if(FillStyleBGroupMixNum>>>28){if(FillStyleBGroupMixNum>>>30){if(FillStyleBGroupMixNum>>>31){currNumFillBits=32;}else{currNumFillBits=31;}}else{if(FillStyleBGroupMixNum>>>29){currNumFillBits=30;}else{currNumFillBits=29;}}}else{if(FillStyleBGroupMixNum>>>26){if(FillStyleBGroupMixNum>>>27){currNumFillBits=28;}else{currNumFillBits=27;}}else{if(FillStyleBGroupMixNum>>>25){currNumFillBits=26;}else{currNumFillBits=25;}}}}else{if(FillStyleBGroupMixNum>>>20){if(FillStyleBGroupMixNum>>>22){if(FillStyleBGroupMixNum>>>23){currNumFillBits=24;}else{currNumFillBits=23;}}else{if(FillStyleBGroupMixNum>>>21){currNumFillBits=22;}else{currNumFillBits=21;}}}else{if(FillStyleBGroupMixNum>>>18){if(FillStyleBGroupMixNum>>>19){currNumFillBits=20;}else{currNumFillBits=19;}}else{if(FillStyleBGroupMixNum>>>17){currNumFillBits=18;}else{currNumFillBits=17;}}}}}else{if(FillStyleBGroupMixNum>>>8){if(FillStyleBGroupMixNum>>>12){if(FillStyleBGroupMixNum>>>14){if(FillStyleBGroupMixNum>>>15){currNumFillBits=16;}else{currNumFillBits=15;}}else{if(FillStyleBGroupMixNum>>>13){currNumFillBits=14;}else{currNumFillBits=13;}}}else{if(FillStyleBGroupMixNum>>>10){if(FillStyleBGroupMixNum>>>11){currNumFillBits=12;}else{currNumFillBits=11;}}else{if(FillStyleBGroupMixNum>>>9){currNumFillBits=10;}else{currNumFillBits=9;}}}}else{if(FillStyleBGroupMixNum>>>4){if(FillStyleBGroupMixNum>>>6){if(FillStyleBGroupMixNum>>>7){currNumFillBits=8;}else{currNumFillBits=7;}}else{if(FillStyleBGroupMixNum>>>5){currNumFillBits=6;}else{currNumFillBits=5;}}}else{if(FillStyleBGroupMixNum>>>2){if(FillStyleBGroupMixNum>>>3){currNumFillBits=4;}else{currNumFillBits=3;}}else{if(FillStyleBGroupMixNum>>>1){currNumFillBits=2;}else{currNumFillBits=FillStyleBGroupMixNum;}}}}}
			if(LineStyleBGroupMixNum>>>16){if(LineStyleBGroupMixNum>>>24){if(LineStyleBGroupMixNum>>>28){if(LineStyleBGroupMixNum>>>30){if(LineStyleBGroupMixNum>>>31){currNumLineBits=32;}else{currNumLineBits=31;}}else{if(LineStyleBGroupMixNum>>>29){currNumLineBits=30;}else{currNumLineBits=29;}}}else{if(LineStyleBGroupMixNum>>>26){if(LineStyleBGroupMixNum>>>27){currNumLineBits=28;}else{currNumLineBits=27;}}else{if(LineStyleBGroupMixNum>>>25){currNumLineBits=26;}else{currNumLineBits=25;}}}}else{if(LineStyleBGroupMixNum>>>20){if(LineStyleBGroupMixNum>>>22){if(LineStyleBGroupMixNum>>>23){currNumLineBits=24;}else{currNumLineBits=23;}}else{if(LineStyleBGroupMixNum>>>21){currNumLineBits=22;}else{currNumLineBits=21;}}}else{if(LineStyleBGroupMixNum>>>18){if(LineStyleBGroupMixNum>>>19){currNumLineBits=20;}else{currNumLineBits=19;}}else{if(LineStyleBGroupMixNum>>>17){currNumLineBits=18;}else{currNumLineBits=17;}}}}}else{if(LineStyleBGroupMixNum>>>8){if(LineStyleBGroupMixNum>>>12){if(LineStyleBGroupMixNum>>>14){if(LineStyleBGroupMixNum>>>15){currNumLineBits=16;}else{currNumLineBits=15;}}else{if(LineStyleBGroupMixNum>>>13){currNumLineBits=14;}else{currNumLineBits=13;}}}else{if(LineStyleBGroupMixNum>>>10){if(LineStyleBGroupMixNum>>>11){currNumLineBits=12;}else{currNumLineBits=11;}}else{if(LineStyleBGroupMixNum>>>9){currNumLineBits=10;}else{currNumLineBits=9;}}}}else{if(LineStyleBGroupMixNum>>>4){if(LineStyleBGroupMixNum>>>6){if(LineStyleBGroupMixNum>>>7){currNumLineBits=8;}else{currNumLineBits=7;}}else{if(LineStyleBGroupMixNum>>>5){currNumLineBits=6;}else{currNumLineBits=5;}}}else{if(LineStyleBGroupMixNum>>>2){if(LineStyleBGroupMixNum>>>3){currNumLineBits=4;}else{currNumLineBits=3;}}else{if(LineStyleBGroupMixNum>>>1){currNumLineBits=2;}else{currNumLineBits=LineStyleBGroupMixNum;}}}}}
			
			//trace("currNumFillBits="+currNumFillBits);
			//trace("currNumLineBits="+currNumLineBits);
			
			var flags:int=0;
			flags|=currNumFillBits<<4;						//11110000
			flags|=currNumLineBits;							//00001111
			data[offset++]=flags;
			
			//var currFillStyleV:Vector.<FILLSTYLE>=FillStyleV;
			//var currLineStyleV:Vector.<LINESTYLE>=LineStyleV;
			//var currLineStyle2V:Vector.<LINESTYLE2>=LineStyle2V;
			
			var bGroupValue:int=0;
			var bGroupBitsOffset:int=0;
			offset=data.length;
			
			var bGroupRshiftBitsOffset:int;
			var NumBits:int;
			var bGroupMixNum:int;
			
			var ShapeRecordId:int=-1;
			for each(var ShapeRecord:SHAPERECORD in ShapeRecordV){
				ShapeRecordId++;
				switch(ShapeRecord.type){
					case ShapeRecordTypes.STRAIGHTEDGERECORD:
						bGroupValue|=0xc0000000>>>bGroupBitsOffset;
						bGroupBitsOffset+=2;
						
						//计算所需最小位数:
						bGroupMixNum=((ShapeRecord.DeltaX<0?-ShapeRecord.DeltaX:ShapeRecord.DeltaX)<<1)|((ShapeRecord.DeltaY<0?-ShapeRecord.DeltaY:ShapeRecord.DeltaY)<<1);
						if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){NumBits=32;}else{NumBits=31;}}else{if(bGroupMixNum>>>29){NumBits=30;}else{NumBits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){NumBits=28;}else{NumBits=27;}}else{if(bGroupMixNum>>>25){NumBits=26;}else{NumBits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){NumBits=24;}else{NumBits=23;}}else{if(bGroupMixNum>>>21){NumBits=22;}else{NumBits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){NumBits=20;}else{NumBits=19;}}else{if(bGroupMixNum>>>17){NumBits=18;}else{NumBits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){NumBits=16;}else{NumBits=15;}}else{if(bGroupMixNum>>>13){NumBits=14;}else{NumBits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){NumBits=12;}else{NumBits=11;}}else{if(bGroupMixNum>>>9){NumBits=10;}else{NumBits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){NumBits=8;}else{NumBits=7;}}else{if(bGroupMixNum>>>5){NumBits=6;}else{NumBits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){NumBits=4;}else{NumBits=3;}}else{if(bGroupMixNum>>>1){NumBits=2;}else{NumBits=bGroupMixNum;}}}}}
						if(NumBits<2){
							NumBits=2;//- -
						}
						bGroupRshiftBitsOffset=32-NumBits;
						
						bGroupValue|=((NumBits-2)<<28)>>>bGroupBitsOffset;
						bGroupBitsOffset+=4;
						
						//向 data 写入满8位(1字节)的数据:
						if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
						
						if(ShapeRecord.DeltaX&&ShapeRecord.DeltaY){
							
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
							bGroupBitsOffset++;
							
							bGroupValue|=(ShapeRecord.DeltaX<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
							bGroupBitsOffset+=NumBits;
							
							//向 data 写入满8位(1字节)的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
							
							bGroupValue|=(ShapeRecord.DeltaY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
							bGroupBitsOffset+=NumBits;
							
						}else if(ShapeRecord.DeltaX){
							
							bGroupBitsOffset+=2;
							
							bGroupValue|=(ShapeRecord.DeltaX<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
							bGroupBitsOffset+=NumBits;
							
						}else{
							
							//如果 ShapeRecord.DeltaY==0 貌似这根直线可以省略了
							
							bGroupBitsOffset++;
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
							bGroupBitsOffset++;
							
							bGroupValue|=(ShapeRecord.DeltaY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
							bGroupBitsOffset+=NumBits;
							
						}
						break;
					case ShapeRecordTypes.CURVEDEDGERECORD:
						bGroupValue|=0x80000000>>>bGroupBitsOffset;
						bGroupBitsOffset+=2
						
						//计算所需最小位数:
						bGroupMixNum=((ShapeRecord.ControlDeltaX<0?-ShapeRecord.ControlDeltaX:ShapeRecord.ControlDeltaX)<<1)|((ShapeRecord.ControlDeltaY<0?-ShapeRecord.ControlDeltaY:ShapeRecord.ControlDeltaY)<<1)|((ShapeRecord.AnchorDeltaX<0?-ShapeRecord.AnchorDeltaX:ShapeRecord.AnchorDeltaX)<<1)|((ShapeRecord.AnchorDeltaY<0?-ShapeRecord.AnchorDeltaY:ShapeRecord.AnchorDeltaY)<<1);
						if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){NumBits=32;}else{NumBits=31;}}else{if(bGroupMixNum>>>29){NumBits=30;}else{NumBits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){NumBits=28;}else{NumBits=27;}}else{if(bGroupMixNum>>>25){NumBits=26;}else{NumBits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){NumBits=24;}else{NumBits=23;}}else{if(bGroupMixNum>>>21){NumBits=22;}else{NumBits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){NumBits=20;}else{NumBits=19;}}else{if(bGroupMixNum>>>17){NumBits=18;}else{NumBits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){NumBits=16;}else{NumBits=15;}}else{if(bGroupMixNum>>>13){NumBits=14;}else{NumBits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){NumBits=12;}else{NumBits=11;}}else{if(bGroupMixNum>>>9){NumBits=10;}else{NumBits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){NumBits=8;}else{NumBits=7;}}else{if(bGroupMixNum>>>5){NumBits=6;}else{NumBits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){NumBits=4;}else{NumBits=3;}}else{if(bGroupMixNum>>>1){NumBits=2;}else{NumBits=bGroupMixNum;}}}}}
						//trace("NumBits="+NumBits);
						if(NumBits<2){
							NumBits=2;//- -
						}
						bGroupRshiftBitsOffset=32-NumBits;
						
						bGroupValue|=((NumBits-2)<<28)>>>bGroupBitsOffset;
						bGroupBitsOffset+=4;
						
						//向 data 写入满8位(1字节)的数据:
						if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
						
						bGroupValue|=(ShapeRecord.ControlDeltaX<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
						bGroupBitsOffset+=NumBits;
						
						//向 data 写入满8位(1字节)的数据:
						if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
						
						bGroupValue|=(ShapeRecord.ControlDeltaY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
						bGroupBitsOffset+=NumBits;
						
						//向 data 写入满8位(1字节)的数据:
						if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
						
						bGroupValue|=(ShapeRecord.AnchorDeltaX<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
						bGroupBitsOffset+=NumBits;
						
						//向 data 写入满8位(1字节)的数据:
						if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
						
						bGroupValue|=(ShapeRecord.AnchorDeltaY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
						bGroupBitsOffset+=NumBits;
						
						break;
					case ShapeRecordTypes.STYLECHANGERECORD:
						if(ShapeRecord.FillStyleV||ShapeRecord.LineStyle2V||ShapeRecord.LineStyleV){
							bGroupBitsOffset++;
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
							bGroupBitsOffset++;
						}else{
							bGroupBitsOffset+=2;
						}
						
						if(ShapeRecord.LineStyle>-1){
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
						}
						bGroupBitsOffset++;
						
						if(ShapeRecord.FillStyle1>-1){
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
						}
						bGroupBitsOffset++;
						
						if(ShapeRecord.FillStyle0>-1){
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
						}
						bGroupBitsOffset++;
						
						//向 data 写入满8位(1字节)的数据:
						if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
						
						if(ShapeRecord.MoveDeltaXY){
							//if(ShapeRecord.MoveDeltaX||ShapeRecord.MoveDeltaY){
							bGroupValue|=0x80000000>>>bGroupBitsOffset;
							bGroupBitsOffset++;
							
							var MoveDeltaX:int=ShapeRecord.MoveDeltaXY[0];
							var MoveDeltaY:int=ShapeRecord.MoveDeltaXY[1];
							//var MoveDeltaX:int=ShapeRecord.MoveDeltaX;
							//var MoveDeltaY:int=ShapeRecord.MoveDeltaY;
							
							//计算所需最小位数:
							bGroupMixNum=((MoveDeltaX<0?-MoveDeltaX:MoveDeltaX)<<1)|((MoveDeltaY<0?-MoveDeltaY:MoveDeltaY)<<1);
							var MoveBits:int;
							if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){MoveBits=32;}else{MoveBits=31;}}else{if(bGroupMixNum>>>29){MoveBits=30;}else{MoveBits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){MoveBits=28;}else{MoveBits=27;}}else{if(bGroupMixNum>>>25){MoveBits=26;}else{MoveBits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){MoveBits=24;}else{MoveBits=23;}}else{if(bGroupMixNum>>>21){MoveBits=22;}else{MoveBits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){MoveBits=20;}else{MoveBits=19;}}else{if(bGroupMixNum>>>17){MoveBits=18;}else{MoveBits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){MoveBits=16;}else{MoveBits=15;}}else{if(bGroupMixNum>>>13){MoveBits=14;}else{MoveBits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){MoveBits=12;}else{MoveBits=11;}}else{if(bGroupMixNum>>>9){MoveBits=10;}else{MoveBits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){MoveBits=8;}else{MoveBits=7;}}else{if(bGroupMixNum>>>5){MoveBits=6;}else{MoveBits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){MoveBits=4;}else{MoveBits=3;}}else{if(bGroupMixNum>>>1){MoveBits=2;}else{MoveBits=bGroupMixNum;}}}}}
							bGroupRshiftBitsOffset=32-MoveBits;
							
							bGroupValue|=(MoveBits<<27)>>>bGroupBitsOffset;
							bGroupBitsOffset+=5;
							
							//向 data 写入满8位(1字节)的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
							
							bGroupValue|=(MoveDeltaX<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
							bGroupBitsOffset+=MoveBits;
							
							//向 data 写入满8位(1字节)的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
							
							bGroupValue|=(MoveDeltaY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
							bGroupBitsOffset+=MoveBits;
							
							//向 data 写入满8位(1字节)的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
							
						}else{
							bGroupBitsOffset++;
						}
						
						if(ShapeRecord.FillStyle0>-1){
							bGroupValue|=ShapeRecord.FillStyle0<<(32-(bGroupBitsOffset+=currNumFillBits));
							
							//向 data 写入满8位(1字节)的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
							
						}
						
						if(ShapeRecord.FillStyle1>-1){
							bGroupValue|=ShapeRecord.FillStyle1<<(32-(bGroupBitsOffset+=currNumFillBits));
							
							//向 data 写入满8位(1字节)的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
							
						}
						
						if(ShapeRecord.LineStyle>-1){
							bGroupValue|=ShapeRecord.LineStyle<<(32-(bGroupBitsOffset+=currNumLineBits));
							
						}
						
						if(ShapeRecord.FillStyleV||ShapeRecord.LineStyle2V||ShapeRecord.LineStyleV){
							
							//向 data 写入有效的数据:
							if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;data[offset++]=bGroupValue;}else{data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;}}else if(bGroupBitsOffset>8){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;}else{data[offset++]=bGroupValue>>24;}
							
							//计算所需最小位数:
							FillStyleBGroupMixNum=0;
							LineStyleBGroupMixNum=0;
							
							for(var currShapeRecordId:int=ShapeRecordId+1;currShapeRecordId<ShapeRecordV.length;currShapeRecordId++){
								calNumBitsShapeRecord=ShapeRecordV[currShapeRecordId];
								if(calNumBitsShapeRecord.type==ShapeRecordTypes.STYLECHANGERECORD){
									if(calNumBitsShapeRecord.FillStyleV||calNumBitsShapeRecord.LineStyle2V||calNumBitsShapeRecord.LineStyleV){
										break;
									}
									if(calNumBitsShapeRecord.FillStyle0>-1){
										FillStyleBGroupMixNum|=calNumBitsShapeRecord.FillStyle0;
									}
									if(calNumBitsShapeRecord.FillStyle1>-1){
										FillStyleBGroupMixNum|=calNumBitsShapeRecord.FillStyle1;
									}
									if(calNumBitsShapeRecord.LineStyle>-1){
										LineStyleBGroupMixNum|=calNumBitsShapeRecord.LineStyle;
									}
								}
							}
							if(FillStyleBGroupMixNum>>>16){if(FillStyleBGroupMixNum>>>24){if(FillStyleBGroupMixNum>>>28){if(FillStyleBGroupMixNum>>>30){if(FillStyleBGroupMixNum>>>31){currNumFillBits=32;}else{currNumFillBits=31;}}else{if(FillStyleBGroupMixNum>>>29){currNumFillBits=30;}else{currNumFillBits=29;}}}else{if(FillStyleBGroupMixNum>>>26){if(FillStyleBGroupMixNum>>>27){currNumFillBits=28;}else{currNumFillBits=27;}}else{if(FillStyleBGroupMixNum>>>25){currNumFillBits=26;}else{currNumFillBits=25;}}}}else{if(FillStyleBGroupMixNum>>>20){if(FillStyleBGroupMixNum>>>22){if(FillStyleBGroupMixNum>>>23){currNumFillBits=24;}else{currNumFillBits=23;}}else{if(FillStyleBGroupMixNum>>>21){currNumFillBits=22;}else{currNumFillBits=21;}}}else{if(FillStyleBGroupMixNum>>>18){if(FillStyleBGroupMixNum>>>19){currNumFillBits=20;}else{currNumFillBits=19;}}else{if(FillStyleBGroupMixNum>>>17){currNumFillBits=18;}else{currNumFillBits=17;}}}}}else{if(FillStyleBGroupMixNum>>>8){if(FillStyleBGroupMixNum>>>12){if(FillStyleBGroupMixNum>>>14){if(FillStyleBGroupMixNum>>>15){currNumFillBits=16;}else{currNumFillBits=15;}}else{if(FillStyleBGroupMixNum>>>13){currNumFillBits=14;}else{currNumFillBits=13;}}}else{if(FillStyleBGroupMixNum>>>10){if(FillStyleBGroupMixNum>>>11){currNumFillBits=12;}else{currNumFillBits=11;}}else{if(FillStyleBGroupMixNum>>>9){currNumFillBits=10;}else{currNumFillBits=9;}}}}else{if(FillStyleBGroupMixNum>>>4){if(FillStyleBGroupMixNum>>>6){if(FillStyleBGroupMixNum>>>7){currNumFillBits=8;}else{currNumFillBits=7;}}else{if(FillStyleBGroupMixNum>>>5){currNumFillBits=6;}else{currNumFillBits=5;}}}else{if(FillStyleBGroupMixNum>>>2){if(FillStyleBGroupMixNum>>>3){currNumFillBits=4;}else{currNumFillBits=3;}}else{if(FillStyleBGroupMixNum>>>1){currNumFillBits=2;}else{currNumFillBits=FillStyleBGroupMixNum;}}}}}
							if(LineStyleBGroupMixNum>>>16){if(LineStyleBGroupMixNum>>>24){if(LineStyleBGroupMixNum>>>28){if(LineStyleBGroupMixNum>>>30){if(LineStyleBGroupMixNum>>>31){currNumLineBits=32;}else{currNumLineBits=31;}}else{if(LineStyleBGroupMixNum>>>29){currNumLineBits=30;}else{currNumLineBits=29;}}}else{if(LineStyleBGroupMixNum>>>26){if(LineStyleBGroupMixNum>>>27){currNumLineBits=28;}else{currNumLineBits=27;}}else{if(LineStyleBGroupMixNum>>>25){currNumLineBits=26;}else{currNumLineBits=25;}}}}else{if(LineStyleBGroupMixNum>>>20){if(LineStyleBGroupMixNum>>>22){if(LineStyleBGroupMixNum>>>23){currNumLineBits=24;}else{currNumLineBits=23;}}else{if(LineStyleBGroupMixNum>>>21){currNumLineBits=22;}else{currNumLineBits=21;}}}else{if(LineStyleBGroupMixNum>>>18){if(LineStyleBGroupMixNum>>>19){currNumLineBits=20;}else{currNumLineBits=19;}}else{if(LineStyleBGroupMixNum>>>17){currNumLineBits=18;}else{currNumLineBits=17;}}}}}else{if(LineStyleBGroupMixNum>>>8){if(LineStyleBGroupMixNum>>>12){if(LineStyleBGroupMixNum>>>14){if(LineStyleBGroupMixNum>>>15){currNumLineBits=16;}else{currNumLineBits=15;}}else{if(LineStyleBGroupMixNum>>>13){currNumLineBits=14;}else{currNumLineBits=13;}}}else{if(LineStyleBGroupMixNum>>>10){if(LineStyleBGroupMixNum>>>11){currNumLineBits=12;}else{currNumLineBits=11;}}else{if(LineStyleBGroupMixNum>>>9){currNumLineBits=10;}else{currNumLineBits=9;}}}}else{if(LineStyleBGroupMixNum>>>4){if(LineStyleBGroupMixNum>>>6){if(LineStyleBGroupMixNum>>>7){currNumLineBits=8;}else{currNumLineBits=7;}}else{if(LineStyleBGroupMixNum>>>5){currNumLineBits=6;}else{currNumLineBits=5;}}}else{if(LineStyleBGroupMixNum>>>2){if(LineStyleBGroupMixNum>>>3){currNumLineBits=4;}else{currNumLineBits=3;}}else{if(LineStyleBGroupMixNum>>>1){currNumLineBits=2;}else{currNumLineBits=LineStyleBGroupMixNum;}}}}}
							
							//trace("currNumFillBits="+currNumFillBits);
							//trace("currNumLineBits="+currNumLineBits);
							
							//currFillStyleV=ShapeRecord.FillStyleV;
							//currLineStyleV=ShapeRecord.LineStyleV;
							//currLineStyle2V=ShapeRecord.LineStyle2V;
							if(ShapeRecord.FillStyleV){
								var currFillStyleCount:int=ShapeRecord.FillStyleV.length;
								if(currFillStyleCount<0xff){
									data[offset++]=currFillStyleCount;
								}else{
									data[offset++]=0xff;
									data[offset++]=currFillStyleCount;
									data[offset++]=currFillStyleCount>>8;
								}
								data.position=offset;
								for each(var currFillStyle:FILLSTYLE in ShapeRecord.FillStyleV){
									data.writeBytes(currFillStyle.toData(_toDataOptions));
								}
								offset=data.length;
							}else{
								data[offset++]=0;
							}
							if(ShapeRecord.LineStyle2V||ShapeRecord.LineStyleV){
								var currLineStyleCount:int=(ShapeRecord.LineStyle2V||ShapeRecord.LineStyleV).length;
								if(currLineStyleCount<0xff){
									data[offset++]=currLineStyleCount;
								}else{
									data[offset++]=0xff;
									data[offset++]=currLineStyleCount;
									data[offset++]=currLineStyleCount>>8;
								}
								data.position=offset;
								if(ShapeRecord.LineStyle2V){
									for each(var currLineStyle2:LINESTYLE2 in ShapeRecord.LineStyle2V){
										data.writeBytes(currLineStyle2.toData(_toDataOptions));
									}
								}else{
									for each(var currLineStyle:LINESTYLE in ShapeRecord.LineStyleV){
										data.writeBytes(currLineStyle.toData(_toDataOptions));
									}
								}
								offset=data.length;
							}else{
								data[offset++]=0;
							}
							flags=0;
							flags|=currNumFillBits<<4;						//11110000
							flags|=currNumLineBits;							//00001111
							data[offset++]=flags;
							bGroupValue=0;
							bGroupBitsOffset=0;
							offset=data.length;
						}
						
						break;
					case ShapeRecordTypes.ENDSHAPERECORD:
						bGroupBitsOffset+=6;
						break;
				}
				
				//向 data 写入满8位(1字节)的数据:
				if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
				
			}
			
			//向 data 写入有效的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;data[offset++]=bGroupValue;}else{data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;}}else if(bGroupBitsOffset>8){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;}else{data[offset++]=bGroupValue>>24;}
			
			return data;
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			var xml:XML=<{xmlName} class="edgarcai.swf.records.shapes.SHAPEWITHSTYLE"/>;
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
			}else if(LineStyleV&&LineStyleV.length){
				var LineStyleListXML:XML=<LineStyleList count={LineStyleV.length}/>
				for each(var LineStyle:LINESTYLE in LineStyleV){
					LineStyleListXML.appendChild(LineStyle.toXML("LineStyle",_toXMLOptions));
				}
				xml.appendChild(LineStyleListXML);
			}
			if(ShapeRecordV.length){
				var ShapeRecordListXML:XML=<ShapeRecordList count={ShapeRecordV.length}/>;
				for each(var ShapeRecord:SHAPERECORD in ShapeRecordV){
					ShapeRecordListXML.appendChild(ShapeRecord.toXML("ShapeRecord",_toXMLOptions));
				}
				xml.appendChild(ShapeRecordListXML);
			}
			return xml;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			var i:int=-1;
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
				for each(var LineStyleXML:XML in xml.LineStyleList.LineStyle){
					i++;
					LineStyleV[i]=new LINESTYLE();
					LineStyleV[i].initByXML(LineStyleXML,_initByXMLOptions);
				}
				if(LineStyleV.length){
				}else{
					LineStyleV=null;
				}
			}
			i=-1;
			ShapeRecordV=new Vector.<SHAPERECORD>();
			for each(var ShapeRecordXML:XML in xml.ShapeRecordList.ShapeRecord){
				i++;
				ShapeRecordV[i]=new SHAPERECORD();
				ShapeRecordV[i].initByXML(ShapeRecordXML,_initByXMLOptions);
			}
		}
	}
}
