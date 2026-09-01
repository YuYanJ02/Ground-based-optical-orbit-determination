stk.v.12.0
WrittenBy    STK_v12.4.0

BEGIN ReportStyle

    BEGIN ClassId
        Class		 Scenario
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
        ClassName		 Scenario
        NameInTitle		 No
        ExpandMethod		 0
        PropMask		 2
        ShowIntervals		 No
        NumIntervals		 0
        NumLines		 1

        BEGIN Line
            Name		 Line 1
            NumElements		 10

            BEGIN Element
                Name		 Time
                IsIndepVar		 Yes
                IndepVarName		 Time
                Title		 Time
                NameInTitle		 No
                Service		 EME2000Vectors
                Type		 Moon accE_BCJ2K
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
                Name		 Vectors(J2000)-Moon accE_BCJ2K-x
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 x
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accE_BCJ2K
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
                Name		 Vectors(J2000)-Moon accE_BCJ2K-y
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 y
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accE_BCJ2K
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
                Name		 Vectors(J2000)-Moon accE_BCJ2K-z
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 z
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accE_BCJ2K
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
                Name		 Vectors(J2000)-Moon accM_BCJ2K-x
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 x
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accM_BCJ2K
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
                Name		 Vectors(J2000)-Moon accM_BCJ2K-y
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 y
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accM_BCJ2K
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
                Name		 Vectors(J2000)-Moon accM_BCJ2K-z
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 z
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accM_BCJ2K
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
                Name		 Vectors(J2000)-Moon accM_ECJ2K-x
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 x
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accM_ECJ2K
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
                Name		 Vectors(J2000)-Moon accM_ECJ2K-y
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 y
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accM_ECJ2K
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
                Name		 Vectors(J2000)-Moon accM_ECJ2K-z
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 z
                NameInTitle		 Yes
                Service		 EME2000Vectors
                Type		 Moon accM_ECJ2K
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
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

