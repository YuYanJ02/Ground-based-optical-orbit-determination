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
        PropMask		 4
        ShowIntervals		 No
        NumIntervals		 0
        NumLines		 1

        BEGIN Line
            Name		 Line 1
            NumElements		 5

            BEGIN Element
                Name		 Astrogator MCS Ephemeris Segments-Segment Name
                IsIndepVar		 No
                Title		 Segment Name
                NameInTitle		 Yes
                Service		 AstrogatorMCSEphemerisSegment
                Element		 Segment Name
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 2
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
                Name		 Astrogator MCS Ephemeris Segments-Segment Type
                IsIndepVar		 No
                Title		 Segment Type
                NameInTitle		 Yes
                Service		 AstrogatorMCSEphemerisSegment
                Element		 Segment Type
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 2
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
                Name		 Astrogator MCS Ephemeris Segments-Start Time
                IsIndepVar		 No
                Title		 Start Time
                NameInTitle		 Yes
                Service		 AstrogatorMCSEphemerisSegment
                Element		 Start Time
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
                Name		 Astrogator MCS Ephemeris Segments-Stop Time
                IsIndepVar		 No
                Title		 Stop Time
                NameInTitle		 Yes
                Service		 AstrogatorMCSEphemerisSegment
                Element		 Stop Time
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
                Name		 Astrogator MCS Ephemeris Segments-Duration
                IsIndepVar		 No
                Title		 Duration
                NameInTitle		 Yes
                Service		 AstrogatorMCSEphemerisSegment
                Element		 Duration
                Format		 %.3f
                SumAllowedMask		 1567
                SummaryOnly		 No
                SumRequestMask		 7
                DataType		 0
                UnitType		 1
                LineStyle		 0
                LineWidth		 0
                PointStyle		 0
                PointSize		 0
                FillPattern		 0
                LineColor		 #000000
                FillColor		 #000000
                PropMask		 0
                BEGIN Event
                    UseEvent		 No
                    EventValue		 0
                    Convergence		 0.002
                    Direction		 Both
                    CreateFile		 No
                END Event
                UseScenUnits		 No
                BEGIN Units
                    TimeUnit		 Days
                END Units
            END Element
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

