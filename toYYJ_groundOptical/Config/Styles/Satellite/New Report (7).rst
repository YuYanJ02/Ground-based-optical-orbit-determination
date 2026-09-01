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
            NumElements		 13

            BEGIN Element
                Name		 SEET SAA Crossing Times-Entrance Pass Number
                IsIndepVar		 No
                Title		 Entrance Pass Number
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Entrance Pass Number
                SumAllowedMask		 32
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
                Name		 SEET SAA Crossing Times-Entrance Time
                IsIndepVar		 No
                Title		 Entrance Time
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Entrance Time
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
                Name		 SEET SAA Crossing Times-Entrance Altitude
                IsIndepVar		 No
                Title		 Entrance Altitude
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Entrance Altitude
                SumAllowedMask		 1559
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
                Name		 SEET SAA Crossing Times-Entrance Latitude
                IsIndepVar		 No
                Title		 Entrance Latitude
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Entrance Latitude
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 0
                UnitType		 19
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
                Name		 SEET SAA Crossing Times-Entrance Longitude
                IsIndepVar		 No
                Title		 Entrance Longitude
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Entrance Longitude
                SumAllowedMask		 0
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
                Name		 SEET SAA Crossing Times-Entrance Flux intensity
                IsIndepVar		 No
                Title		 Entrance Flux intensity
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Entrance Flux intensity
                Format		 %.3f
                SumAllowedMask		 1556
                SummaryOnly		 No
                DataType		 3
                UnitType		 15001
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
                Name		 SEET SAA Crossing Times-Exit Pass Number
                IsIndepVar		 No
                Title		 Exit Pass Number
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Exit Pass Number
                SumAllowedMask		 32
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
                Name		 SEET SAA Crossing Times-Exit Time
                IsIndepVar		 No
                Title		 Exit Time
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Exit Time
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
                Name		 SEET SAA Crossing Times-Exit Altitude
                IsIndepVar		 No
                Title		 Exit Altitude
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Exit Altitude
                SumAllowedMask		 1559
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
                Name		 SEET SAA Crossing Times-Exit Latitude
                IsIndepVar		 No
                Title		 Exit Latitude
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Exit Latitude
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 0
                UnitType		 19
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
                Name		 SEET SAA Crossing Times-Exit Longitude
                IsIndepVar		 No
                Title		 Exit Longitude
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Exit Longitude
                SumAllowedMask		 0
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
                Name		 SEET SAA Crossing Times-Exit Flux intensity
                IsIndepVar		 No
                Title		 Exit Flux intensity
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Exit Flux intensity
                Format		 %.3f
                SumAllowedMask		 1556
                SummaryOnly		 No
                DataType		 3
                UnitType		 15001
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
                Name		 SEET SAA Crossing Times-Duration
                IsIndepVar		 No
                Title		 Duration
                NameInTitle		 Yes
                Service		 SpEnvSAATimesDP
                Element		 Duration
                SumAllowedMask		 1759
                SummaryOnly		 No
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
                UseScenUnits		 Yes
            END Element
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

