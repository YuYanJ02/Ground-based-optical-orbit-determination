stk.v.11.0
WrittenBy    STK_v11.6.0

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
        VerticalGridLines		 No
        HorizontalGridLines		 No
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
            Use		 0
            Destination		 1
            Use		 0
            Destination		 2
            Use		 0
            Destination		 3
            Use		 0
        END PostProcessor
        NumSections		 1
    END Header

    BEGIN Section
        Name		 Section 1
        ClassName		 Satellite
        NameInTitle		 No
        ExpandMethod		 0
        PropMask		 516
        ShowIntervals		 No
        NumIntervals		 0
        NumLines		 1

        BEGIN Line
            Name		 Line 1
            NumElements		 11

            BEGIN Element
                Name		 Eclipse Summary-Penumbra Start Time
                IsIndepVar		 No
                Title		 Penumbra Start Time
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Penumbra Start Time
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 3
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
                Name		 Eclipse Summary-Umbra Start Time
                IsIndepVar		 No
                Title		 Umbra Start Time
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Umbra Start Time
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 3
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
                Name		 Eclipse Summary-Umbra Stop Time
                IsIndepVar		 No
                Title		 Umbra Stop Time
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Umbra Stop Time
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 3
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
                Name		 Eclipse Summary-Penumbra Stop Time
                IsIndepVar		 No
                Title		 Penumbra Stop Time
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Penumbra Stop Time
                SumAllowedMask		 0
                SummaryOnly		 No
                DataType		 3
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
                Name		 Eclipse Summary-Umbra Duration
                IsIndepVar		 No
                Title		 Umbra Duration
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Umbra Duration
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

            BEGIN Element
                Name		 Eclipse Summary-Penumbra Duration
                IsIndepVar		 No
                Title		 Penumbra Duration
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Penumbra Duration
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

            BEGIN Element
                Name		 Eclipse Summary-Total Duration
                IsIndepVar		 No
                Title		 Total Duration
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Total Duration
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

            BEGIN Element
                Name		 Eclipse Summary-Obstruction
                IsIndepVar		 No
                Title		 Obstruction
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Obstruction
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
                Name		 Eclipse Summary-Min Intensity
                IsIndepVar		 No
                Title		 Min Intensity
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Min Intensity
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
                Name		 Eclipse Summary-Max Percent Shadow
                IsIndepVar		 No
                Title		 Max Percent Shadow
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Max Percent Shadow
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
                Name		 Eclipse Summary-Time at Min Intensity
                IsIndepVar		 No
                Title		 Time at Min Intensity
                NameInTitle		 Yes
                Service		 EclipseSummary
                Element		 Time at Min Intensity
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
        END Line
    END Section

    BEGIN LineAnnotations
    END LineAnnotations
END ReportStyle

