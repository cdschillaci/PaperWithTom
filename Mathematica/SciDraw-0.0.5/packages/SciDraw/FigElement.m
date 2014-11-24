(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* :Title: FigElement *)
(* :Context: SciDraw` *)
(* :Summary: Coordinate system infrastructure *)
(* :Author: Mark A. Caprio, Department of Physics, University of Notre Dame *)
(* :Copyright: Copyright FIGYEAR, Mark A. Caprio *)
(* :Package Version: FIGVERSION *)
(* :Mathematica Version: MATHVERSION *)
(* :Discussion: FIGDISCUSSION *)
(* :History: See main package file. *)


BeginPackage["SciDraw`",SciDraw`Private`$ExternalContexts];


Unprotect[Evaluate[$Context<>"*"]];


Begin["`Private`"];





MakeLineDirectives[FullOptions_List]:=Module[
{TheShow,TheColor,TheOpacity},

TheShow=ResolveOption[ShowLine,{Default:>(Show/.FullOptions)},FullOptions];
TheColor=ResolveOption[LineColor,{Default:>(Color/.FullOptions)},FullOptions];
TheOpacity=ResolveOption[LineOpacity,{Default:>(Opacity/.FullOptions)},FullOptions];

If[(TheColor===None)||(!TheShow),Return[None]];

Flatten[
{
If[TheOpacity===None,{},Opacity[TheOpacity]],  (* opacity must precede color if color with embedded transparency is to have effect *)
TheColor,
FigResolveThickness[(LineThickness/.FullOptions)],
FigResolveDashing[(LineDashing/.FullOptions)],
CapForm[LineCapForm/.FullOptions],
JoinForm[LineJoinForm/.FullOptions],
(LineDirectives/.FullOptions)
}
]
];


MakeFillDirectives[FullOptions_List]:=Module[
{TheShow,TheColor,TheOpacity},

TheShow=ResolveOption[ShowFill,{Default:>(Show/.FullOptions)},FullOptions];
TheColor=ResolveOption[FillColor,{Default:>(Color/.FullOptions)},FullOptions];
TheOpacity=ResolveOption[FillOpacity,{Default:>(Opacity/.FullOptions)},FullOptions];

If[(TheColor===None)||(!TheShow),Return[None]];

Flatten[
{
If[TheOpacity===None,{},Opacity[TheOpacity]],  (* opacity must precede color if color Tranparent is to have effect *)
TheColor,
(FillDirectives/.FullOptions)
}
]
];


MakePointDirectives[FullOptions_List]:=Module[
{TheShow,TheColor,TheOpacity},

TheShow=ResolveOption[ShowPoint,{Default:>(Show/.FullOptions)},FullOptions];
TheColor=ResolveOption[PointColor,{Default:>(Color/.FullOptions)},FullOptions];
TheOpacity=ResolveOption[PointOpacity,{Default:>(Opacity/.FullOptions)},FullOptions];

If[(TheColor===None)||(!TheShow),Return[None]];

Flatten[
{
If[TheOpacity===None,{},Opacity[TheOpacity]],
TheColor,
FigResolvePointSize[(PointSize/.FullOptions)],
(PointDirectives/.FullOptions)
}
]
];


Constructor[Class:FigLineElement,Self_Object][Primatives_List,FullOptions_List]:=Module[
{LineDirectives,StyledPrimatives},

(* generate styling *)
LineDirectives=MakeLineDirectives[FullOptions];

(* short circuit if no show -- no data saved, no emission of object reference to $GraphicalElementList *)
If[LineDirectives===None,Return[]];

(* generate graphics *)
StyledPrimatives=Join[
LineDirectives,
(Directives/.FullOptions),
Primatives
];
Self@SetPrimatives[StyledPrimatives];

(* save layer and sequence information *)
Self@SetSortKey[{ResolveOption[Layer,{Automatic:>$FigDrawingLayer},FullOptions],Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
]


Constructor[Class:FigPolygonElement,Self_Object][Primatives_List,FullOptions_List]:=Module[
{LineDirectives,FillDirectives,PolygonDirectives,StyledPrimatives},

(* generate styling *)
LineDirectives=MakeLineDirectives[FullOptions];
FillDirectives=MakeFillDirectives[FullOptions];

(* short circuit if no show -- no data saved, no emission of object reference to $GraphicalElementList *)
If[{LineDirectives,FillDirectives}==={None,None},Return[]];

(* else control display of edge and face separately *)
(* note EdgeForm[None] is accepted as equivalent to EdgeForm[], and FaceForm[None] is accepted as equivalent to FaceForm[] *)
PolygonDirectives={
EdgeForm[LineDirectives],
FaceForm[FillDirectives]
};

(* generate graphics *)
StyledPrimatives=Join[
PolygonDirectives,
(Directives/.FullOptions),
Primatives
];
Self@SetPrimatives[StyledPrimatives];

(* save layer and sequence information *)
Self@SetSortKey[{ResolveOption[Layer,{Automatic:>$FigDrawingLayer},FullOptions],Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
]


Constructor[Class:FigPointElement,Self_Object][Primatives_List,FullOptions_List]:=Module[
{PointDirectives,StyledPrimatives},

(* generate styling *)
PointDirectives=MakePointDirectives[FullOptions];

(* short circuit if no show -- no data saved, no emission of object reference to $GraphicalElementList *)
If[PointDirectives===None,Return[]];

(* generate graphics *)
StyledPrimatives=Join[
PointDirectives,
(Directives/.FullOptions),
Primatives
];
Self@SetPrimatives[StyledPrimatives];

(* save layer and sequence information *)
Self@SetSortKey[{ResolveOption[Layer,{Automatic:>$FigDrawingLayer},FullOptions],Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
]


Constructor[Class:FigVerbatimElement,Self_Object][Primatives_List,FullOptions_List]:=Module[
{StyledPrimatives},

(* short circuit if no show *)
(* no data saved, no emission of object reference to $GraphicalElementList *)
If[!(Show/.FullOptions),Return[]];

(* generate graphics *)
Self@SetPrimatives[Primatives];

(* save layer and sequence information *)
Self@SetSortKey[{ResolveOption[Layer,{Automatic:>$FigDrawingLayer},FullOptions],Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
]


FigStyledText[TextArt_,FullOptions_List]:=Module[
{TheShow,TheColor,TheOpacity,StyleOptions},

If[(TextArt===None),Return[None]];

TheShow=ResolveOption[ShowText,{Default:>(Show/.FullOptions)},FullOptions];
TheColor=ResolveOption[TextColor,{Default:>(Color/.FullOptions)},FullOptions];
TheOpacity=ResolveOption[TextOpacity,{Default:>(Opacity/.FullOptions)},FullOptions];
If[(TheColor===None)||(!TheShow),Return[None]];

StyleOptions=Flatten[
{
(* use directives rather than options for coloring, for better precedence control over color vs. opacity vs. Transparent *)
If[TheOpacity===None,{},Opacity[TheOpacity]],(* opacity must precede color if color Tranparent is to have effect *)
TheColor,
FilterRules[FullOptions,{FontFamily,FontSize,FontWeight,FontSlant,FontTracking,FontVariations}],
ShowAutoStyles->False,SingleLetterItalics->False,
(TextStyleOptions/.FullOptions)  (* directives at right will override any options to left *)
}
];
Style[DisplayForm[TextArt],StyleOptions]
];


MakeTextPositioningParameters[a:ObjectPattern[FigAnchor],FullOptions_List]:=Module[
{
AnchorPoint,AnchorOffset,AnchorAngle,
BaselineAngle,Invert,InvertOffset,
InitialPoint,
UsedPoint,UsedAngle,UsedOrientation,UsedOffset,BufferDirection
},

(* default extraction from anchor *)
AnchorPoint=a@GetPoint[];
AnchorOffset=a@GetOffset[];
AnchorAngle=a@GetAngle[];

(* retain initial point, e.g., for later use in callout *)
InitialPoint = AnchorPoint;

(* flag need for rectification *)
BaselineAngle=Mod[N@AnchorAngle,N@2*Pi,N@-Pi];
Invert=((TextRectify/.FullOptions)&&!((-Pi/2<BaselineAngle)&&(BaselineAngle<=Pi/2)));

(* determine angle *)
UsedAngle=Switch[
(TextOrientation/.FullOptions),
Automatic,AnchorAngle+If[Invert,N[Pi],0],
Inverse,AnchorAngle+If[!Invert,N[Pi],0],
Horizontal,0,
Vertical,Pi/2,
_?NumericQ,(TextOrientation/.FullOptions)
];
InvertOffset=Switch[
(TextOrientation/.FullOptions),
Automatic,Invert,
Inverse,!Invert,
_,False
];

(* determine orientation unit vector *)
UsedOrientation={Cos[UsedAngle],Sin[UsedAngle]};

(* determine offset *)
(* must be inverted if text display is inverted *)
UsedOffset=If[InvertOffset,-1,+1]*FigResolveOffset[ResolveOption[TextOffset,{Automatic->AnchorOffset},FullOptions]];

(* determine buffering *)
(* "outward" direction is determined from *original* anchor positioning parameters, since possible later overrides, e.g., to Horizontal, would throw off the direction *)
BufferDirection=If[
VectorLength[AnchorOffset]==0,{0,0},
(-1)*RotationTransform[N@AnchorAngle][AnchorOffset/VectorLength[AnchorOffset]]
];

(* determine buffered and nudged position *)
(* note that classic LevelScheme Nudge\[Rule]dy form is supported here, with UpgradePairVertical, but generally disallowed in the option validation,
as idiosyncratic and incompatible with panel edge upgrade *)
UsedPoint=AnchorPoint
+UpgradeScalar[ResolveOption[TextBaseBuffer,{Automatic:>$FigTextBaseBuffer},FullOptions]]*BufferDirection
+UpgradeScalar[(TextBuffer/.FullOptions)]*BufferDirection
+UpgradePairVertical[(TextNudge/.FullOptions)];

{InitialPoint,UsedPoint,UsedOffset,UsedOrientation}
];


MakeTextFrameOptions[Visible:LogicalPattern,FullOptions_List]:=Module[
{TheBackgroundColor,TheFrameColor},

TheBackgroundColor=ResolveOption[TextBackground,{Automatic:>CurrentBackground[]},FullOptions];  
TheFrameColor=ResolveOption[TextFrameColor,{Default:>(TextColor/.FullOptions),Default:>(Color/.FullOptions)},FullOptions];

{

(* visibility and color *)
Background->If[Visible&&(TheBackgroundColor=!=None),TheBackgroundColor,None],
FrameStyle->If[Visible&&(TextFrame/.FullOptions)&&(TheFrameColor=!=None),TheFrameColor,None],

(* geometry *)
FrameMargins->(UpgradeRangeParameters[TextMargin/.FullOptions]),
RoundingRadius->UpgradePairEqual[(TextRoundingRadius/.FullOptions)],
ContentPadding->(TextPadding/.FullOptions)

}
];


MakeTextCalloutOptions[FullOptions_List]:=Module[
{},

{
ShowLine->(TextCallout/.FullOptions),
LineColor->(TextCalloutColor/.FullOptions),
LineOpacity->(TextCalloutOpacity/.FullOptions),
LineThickness->(TextCalloutThickness/.FullOptions),
LineDashing->(TextCalloutDashing/.FullOptions),
LineCapForm->(TextCalloutCapForm/.FullOptions),
LineJoinForm->(TextCalloutJoinForm/.FullOptions),
LineDirectives->(TextCalloutDirectives/.FullOptions)
}
];


Constructor[Class:FigTextElement,Self_Object][a:ObjectPattern[FigAnchor],TextArt_,FullOptions_List]:=Module[
{
InitialPoint,UsedPoint,UsedOrientation,UsedOffset,
StyledText,FramedText,TextPrimative,
CanvasCenter,CanvasPivot,CanvasRadius,RotationAngle
},

(* format text *)
StyledText=FigStyledText[TextArt,FullOptions];

(* short circuit if nothing to display -- no show, no show text, no art*)
(* no data saved, no emission of object reference to $GraphicalElementList *)
(* except we had better save a null radius, which will be used, e.g., in tick size calculation *)
If[
StyledText===None,
Self@SetRadius[{0,0}];
Return[]
];

(* generate position information *)
{InitialPoint,UsedPoint,UsedOffset,UsedOrientation}=MakeTextPositioningParameters[a,FullOptions];

(* generate text graphics *)
FramedText=Framed[StyledText,MakeTextFrameOptions[False,FullOptions]];
TextPrimative=Text[FramedText,UsedPoint,UsedOffset,UsedOrientation];
Self@SetPrimatives[{TextPrimative}];
If[
(Debug/.FullOptions),
Print["  ",FramedText]
];

(* extract and save "rectangle" data *)
CanvasRadius=N@Most[Rasterize[FramedText,"BoundingBox"]]/2;
CanvasPivot=UsedPoint;
CanvasCenter=CanvasPivot-UsedOffset*CanvasRadius;
RotationAngle=VectorArcTan[UsedOrientation];
Self@SetInitialPoint[InitialPoint];
Self@SetCenter[CanvasCenter];
Self@SetRadius[CanvasRadius];
Self@SetPivot[CanvasPivot];
Self@SetRotation[RotationAngle];
If[
(Debug/.FullOptions),
Print["  ","Text element: ","offset ",UsedOffset,", orientation ",UsedOrientation," -- ","center ",CanvasCenter,", pivot ",CanvasPivot,", radius ",CanvasRadius,", angle ",Row[{RotationAngle/Degree,Degree}]]
];

(* spawn callout line as separate graphical element (in different layer) *)
MakeTextCalloutElement[{InitialPoint,UsedPoint},FullOptions];

(* spawn frame as separate graphical element (in different layer) *)
(* TO REVISIT -- does cost of separate frame justify occasional benefit? *)
FigTextFrameElement[{UsedPoint,UsedOrientation,UsedOffset},StyledText,FullOptions];

(* save layer and sequence information *)
Self@SetSortKey[{ResolveOption[Layer,{Automatic:>$FigTextLayer},FullOptions],Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
];


MakeTextCalloutElement[{InitialPoint_,UsedPoint_},FullOptions_List]:=Module[
{},

(* generate callout graphics *)
CompositeOptions=Join[MakeTextCalloutOptions[FullOptions],FullOptions];
FigLineElement[{Line[{UsedPoint,InitialPoint}]},CompositeOptions];
];


Constructor[Class:FigTextFrameElement,Self_Object][{UsedPoint_,UsedOrientation_,UsedOffset_},StyledText_,FullOptions_List]:=Module[
{},

(* TO REVISIT -- does cost of separate frame justify occasional benefit? what about Invisible text, which seems to appear in Export? *)

(* generate frame graphics *)
FramedText=Framed[Invisible[StyledText],MakeTextFrameOptions[True,FullOptions]];
TextPrimative=Text[FramedText,UsedPoint,UsedOffset,UsedOrientation];
Self@SetPrimatives[{TextPrimative}];

(* save layer and sequence information *)
Self@SetSortKey[{ResolveOption[Layer,{Automatic:>$FigBlankingLayer},FullOptions],Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
];



FigAssemblePrimatives[GraphicalElementList_List]:=Module[
{SortedGraphicalElementList},

(* sort by layer then creation sequence within layer *)
(* Note: Full sequencing information must be used in the sort key, since SortBy is not order preserving. *)
SortedGraphicalElementList=SortBy[GraphicalElementList,(#@GetSortKey[]&)];

(* assemble primative list *)
Map[(#@GetPrimatives[]&),SortedGraphicalElementList]
];


FigWindowPrimatives[r:NumericalRegionPattern,Primatives_List]:={
(* define host rectangle *)
(* outer braces serve to scope FaceForm so it only applies to outer rectangle -- else will affect any inset graphics if not overridden by a FaceForm in the inset graphics *)
{FaceForm[None],Rectangle@@Transpose[r]},
(* define inset *)
Inset[
Graphics[
Primatives,
Frame->False,
PlotRange->r,  (* set clipping region *)
ImageSize->-Subtract@@@r   (* set inset size to natural size *)
],
{0,0},{0,0} (* align inset coordinates with page coordinates *)
]
};


FigWindowPrimativesRaster[r:NumericalRegionPattern,Resolution_?Positive,Primatives_List]:={
(* define host rectangle *)
(*Transparent*)FaceForm[None],
Rectangle@@Transpose[r],
(* define inset *)
Inset[
Rasterize[
Graphics[
Primatives,
Frame->False,
PlotRange->r,  (* set clipping region *)
ImageSize->-Subtract@@@r   (* set inset size to natural size *)
],
ImageResolution->Resolution,
Background->None
]
]
};


SetAttributes[CollectGraphicalElements,{HoldFirst}];
CollectGraphicalElements[Body_,Window:ObjectPattern[FigWindow],EffectiveBackground_]:=
(* create panel graphical elements *)
Block[
{
$CurrentWindow=Window,
$CurrentBackground=EffectiveBackground,
$GraphicalElementList={}
},

Body;

$GraphicalElementList
];


Constructor[Class:FigCompositeElement,Self_Object][GraphicalElementList_List,Window:ObjectPattern[FigWindow],Layer_?NumericQ,Opts___?OptionQ]:=Module[
{
FullOptions=RealizeOptions[FigCompositeElement,Opts],
PrimativeList,WindowPrimatives,ClippingRegion
},

(* short circuit if no show *)
(* no data saved, no emission of object reference to $GraphicalElementList *)
If[!(Show/.FullOptions),Return[]];

(* assemble primatives list *)
PrimativeList=FigAssemblePrimatives[GraphicalElementList];

(* apply window *)
ClippingRegion=If[
(Clip/.FullOptions),
Window@CanvasRegion[],
$CanvasFullRange
];

WindowPrimatives=If[
(Rasterize/.FullOptions),
FigWindowPrimativesRaster[ClippingRegion,(ImageResolution/.FullOptions),PrimativeList],
FigWindowPrimatives[ClippingRegion,PrimativeList]
];
Self@SetPrimatives[WindowPrimatives];

(* save layer and sequence information *)
Self@SetSortKey[{Layer,Length[$GraphicalElementList]}];

(* emit graphics *)
AppendTo[$GraphicalElementList,Self]
];


SetAttributes[FigureGroup,HoldFirst]


Options[FigureGroup]=Join[
Options[FigCompositeElement],
{Layer->Automatic}
];
RegisterFigOptions[FigureGroup];


FigureGroup[Body_List,Opts___?OptionQ]:=Module[
{
FullOptions=RealizeOptions[FigureGroup,Opts]
},

FigCompositeElement[
CollectGraphicalElements[
ScopeOptions[ScopeOptionOverrides[
Body
]],
CurrentWindow[],CurrentBackground[]
],
CurrentWindow[],
ResolveOption[Layer,{Automatic->$FigDrawingLayer},FullOptions],
FilterRules[FullOptions,Options[FigCompositeElement]]
]
];


End[];


Protect[Evaluate[$Context<>"*"]];
Unprotect[Evaluate[$Context<>"$*"]];
EndPackage[];
