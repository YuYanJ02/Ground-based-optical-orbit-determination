stk.v.11.0
WrittenBy    STK_v11.0.1

BEGIN ReportStyle

BEGIN ClassId
	Class		Satellite
END ClassId

BEGIN Header
	StyleType		0
	Title		J2000 Position & Velocity
	Date		Yes
	Name		Yes
	IsHidden		No
	DescShort		No
	DescLong		No
	YLog10		No
	Y2Log10		No
	YUseWholeNumbers		No
	Y2UseWholeNumbers		No
	VerticalGridLines		No
	HorizontalGridLines		No
	AnnotationType		Spaced
	NumAnnotations		3
	NumAngularAnnotations		5
	ShowYAnnotations		Yes
	AnnotationRotation		1
	BackgroundColor		#ffffff
	ForegroundColor		#000000
	ViewableDuration		0.000000
	RealTimeMode		No
	DayLinesStatus		1
	LegendStatus		1
	LegendLocation		1

BEGIN PostProcessor
	Destination	0
	Use	0
	Destination	1
	Use	0
	Destination	2
	Use	0
	Destination	3
	Use	0
END PostProcessor
	NumSections		1
END Header

BEGIN Section
	Name		Section 1
	ClassName		Satellite
	NameInTitle		No
	ExpandMethod		0
	PropMask		2
	ShowIntervals		No
	NumIntervals		0
	NumLines		1

BEGIN Line
	Name		Line 1
	NumElements		7

BEGIN Element
	Name		Time
	IsIndepVar		Yes
	IndepVarName		Time
	Title		Time
	NameInTitle		No
	Service		CartPos
	Type		J2000
	Element		Time
	SumAllowedMask		0
	SummaryOnly		No
	DataType		0
	UnitType		2
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		No
BEGIN Units
		DateFormat		EpochDays
END Units
END Element

BEGIN Element
	Name		Cartesian Position-J2000-x
	IsIndepVar		No
	IndepVarName		Time
	Title		x
	NameInTitle		No
	Service		CartPos
	Type		J2000
	Element		x
	SumAllowedMask		0
	SummaryOnly		No
	DataType		0
	UnitType		0
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		Yes
END Element

BEGIN Element
	Name		Cartesian Position-J2000-y
	IsIndepVar		No
	IndepVarName		Time
	Title		y
	NameInTitle		No
	Service		CartPos
	Type		J2000
	Element		y
	SumAllowedMask		0
	SummaryOnly		No
	DataType		0
	UnitType		0
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		Yes
END Element

BEGIN Element
	Name		Cartesian Position-J2000-z
	IsIndepVar		No
	IndepVarName		Time
	Title		z
	NameInTitle		Yes
	Service		CartPos
	Type		J2000
	Element		z
	SumAllowedMask		1543
	SummaryOnly		No
	DataType		0
	UnitType		0
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		Yes
END Element

BEGIN Element
	Name		Cartesian Velocity-J2000-x
	IsIndepVar		No
	IndepVarName		Time
	Title		vx
	NameInTitle		Yes
	Service		CartVel
	Type		J2000
	Element		x
	SumAllowedMask		1543
	SummaryOnly		No
	DataType		0
	UnitType		4
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		Yes
END Element

BEGIN Element
	Name		Cartesian Velocity-J2000-y
	IsIndepVar		No
	IndepVarName		Time
	Title		vy
	NameInTitle		Yes
	Service		CartVel
	Type		J2000
	Element		y
	SumAllowedMask		1543
	SummaryOnly		No
	DataType		0
	UnitType		4
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		Yes
END Element

BEGIN Element
	Name		Cartesian Velocity-J2000-z
	IsIndepVar		No
	IndepVarName		Time
	Title		vz
	NameInTitle		Yes
	Service		CartVel
	Type		J2000
	Element		z
	SumAllowedMask		1543
	SummaryOnly		No
	DataType		0
	UnitType		4
	LineStyle		0
	LineWidth		0
	LineColor		#000000
	PointStyle		0
	PointSize		0
	FillPattern		0
	FillColor		#000000
	PropMask		0
	UseScenUnits		Yes
END Element
END Line
END Section

BEGIN LineAnnotations
END LineAnnotations
END ReportStyle

