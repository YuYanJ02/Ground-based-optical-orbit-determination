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
            NumElements		 3

            BEGIN Element
                Name		 Time
                IsIndepVar		 Yes
                IndepVarName		 Time
                Title		 Time
                NameInTitle		 No
                Service		 CovarProjChoosePlane
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
                Name		 Position Covariance Projection Choose Plane-Major Sigma
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Major Sigma
                NameInTitle		 Yes
                Service		 CovarProjChoosePlane
                Element		 Major Sigma
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 0
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
                Name		 Position Covariance Projection Choose Plane-Minor Sigma
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Minor Sigma
                NameInTitle		 Yes
                Service		 CovarProjChoosePlane
                Element		 Minor Sigma
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 0
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

