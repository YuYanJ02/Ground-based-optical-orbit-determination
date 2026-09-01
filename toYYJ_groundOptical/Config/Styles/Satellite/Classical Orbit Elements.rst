stk.v.12.0
WrittenBy    STK_v12.4.0

BEGIN ReportStyle

    BEGIN ClassId
        Class		 Satellite
    END ClassId

    BEGIN Header
        StyleType		 0
        Title		 J2000 Classical Orbit Elements
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
        ViewableDuration		 0
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
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
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
                Name		 Classical Elements-AlignmentAtEpoch-Semi-major Axis
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Semi-major Axis
                NameInTitle		 Yes
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
                Element		 Semi-major Axis
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
                Name		 Classical Elements-AlignmentAtEpoch-Eccentricity
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Eccentricity
                NameInTitle		 Yes
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
                Element		 Eccentricity
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
                Name		 Classical Elements-AlignmentAtEpoch-Inclination
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Inclination
                NameInTitle		 Yes
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
                Element		 Inclination
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 3
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
                Name		 Classical Elements-AlignmentAtEpoch-RAAN
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 RAAN
                NameInTitle		 Yes
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
                Element		 RAAN
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 20
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
                Name		 Classical Elements-AlignmentAtEpoch-Arg of Perigee
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 Arg of Perigee
                NameInTitle		 Yes
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
                Element		 Arg of Perigee
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 3
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
                Name		 Classical Elements-AlignmentAtEpoch-True Anomaly
                IsIndepVar		 No
                IndepVarName		 Time
                Title		 True Anomaly
                NameInTitle		 Yes
                Service		 ModOrbElem
                Type		 AlignmentAtEpoch
                Element		 True Anomaly
                SumAllowedMask		 1543
                SummaryOnly		 No
                DataType		 0
                UnitType		 3
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

