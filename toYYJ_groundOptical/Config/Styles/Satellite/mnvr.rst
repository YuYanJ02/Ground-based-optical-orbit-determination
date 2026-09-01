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
            NumElements		 4

            BEGIN Element
                Name		 Maneuver Summary-Maneuver Number
                IsIndepVar		 No
                Title		 Maneuver Number
                NameInTitle		 Yes
                Service		 ManeuverSummary
                Element		 Maneuver Number
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 1
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
                Name		 Maneuver Summary-Segment
                IsIndepVar		 No
                Title		 Segment
                NameInTitle		 Yes
                Service		 ManeuverSummary
                Element		 Segment
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
                Name		 Maneuver Summary-Start Time
                IsIndepVar		 No
                Title		 Start Time
                NameInTitle		 Yes
                Service		 ManeuverSummary
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
                UseScenUnits		 No
                BEGIN Units
                    DateFormat		 GregorianLCL
                END Units
            END Element

            BEGIN Element
                Name		 Maneuver Summary-Delta V
                IsIndepVar		 No
                Title		 Delta V
                NameInTitle		 Yes
                Service		 ManeuverSummary
                Element		 Delta V
                Format		 %.6f
                SumAllowedMask		 1567
                SummaryOnly		 No
                SumRequestMask		 8
                DataType		 0
                UnitType		 33
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
                UseScenUnits		 Yes
            END Element
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

