stk.v.12.0
WrittenBy    STK_v12.4.0

BEGIN ReportStyle

    BEGIN ClassId
        Class		 Satellite
    END ClassId

    BEGIN Header
        StyleType		 0
        Date		 Yes
        Name		 Yes
        IsHidden		 No
        DescShort		 No
        DescLong		 No
        YLog10		 No
        Y2Log10		 No
        YUseWholeNumbers		 No
        Y2UseWholeNumbers		 No
        InvertAxes		 No
        VerticalGridLines		 No
        HorizontalGridLines		 No
        HorizontalGridBands		 Yes
        AnnotationType		 Spaced
        NumAnnotations		 3
        NumAngularAnnotations		 5
        ShowYAnnotations		 Yes
        AnnotationRotation		 1
        BackgroundColor		 #ffffff
        ForegroundColor		 #000000
        ViewableDuration		 3600
        RealTimeMode		 No
        DayLinesStatus		 1
        LegendStatus		 1
        LegendLocation		 1

        BEGIN PostProcessor
            Destination		 0
            Destination		 1
            Destination		 2
            Destination		 3
        END PostProcessor
        NumSections		 1
    END Header

    BEGIN Section
        Name		 Section 1
        ClassName		 Satellite
        NameInTitle		 No
        ExpandMethod		 0
        PropMask		 2
        ShowIntervals		 No
        NumIntervals		 0
        NumLines		 1

        BEGIN Line
            Name		 Line 1
            NumElements		 7

            BEGIN Element
                Name		 Time
                IsIndepVar		 Yes
                IndepVarName		 Time
                Title		 Time
                NameInTitle		 No
                Service		 VectorChooseAxes
                Type		 uThrust
                Element		 Time
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 0
                UnitType		 2
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Vector Choose Axes-uThrust-x
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 x
                NameInTitle		 Yes
                Service		 VectorChooseAxes
                Type		 uThrust
                Element		 x
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 6
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Vector Choose Axes-uThrust-y
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 y
                NameInTitle		 Yes
                Service		 VectorChooseAxes
                Type		 uThrust
                Element		 y
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 6
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Vector Choose Axes-uThrust-z
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 z
                NameInTitle		 Yes
                Service		 VectorChooseAxes
                Type		 uThrust
                Element		 z
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 6
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Vector Choose Axes-uThrust-Magnitude
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Magnitude
                NameInTitle		 Yes
                Service		 VectorChooseAxes
                Type		 uThrust
                Element		 Magnitude
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 6
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Vector Choose Axes-uNature-Magnitude
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Magnitude
                NameInTitle		 Yes
                Service		 VectorChooseAxes
                Type		 uNature
                Element		 Magnitude
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 11
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element

            BEGIN Element
                Name		 Vector Choose Axes-uToT-Magnitude
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Magnitude
                NameInTitle		 Yes
                Service		 VectorChooseAxes
                Type		 uToT
                Element		 Magnitude
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 11
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                UseScenUnits		 Yes
            END Element
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

