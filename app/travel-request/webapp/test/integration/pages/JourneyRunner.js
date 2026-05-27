sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"travelrequest/test/integration/pages/TravelRequestsList",
	"travelrequest/test/integration/pages/TravelRequestsObjectPage",
	"travelrequest/test/integration/pages/TravelDocumentsObjectPage"
], function (JourneyRunner, TravelRequestsList, TravelRequestsObjectPage, TravelDocumentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('travelrequest') + '/test/flp.html#app-preview',
        pages: {
			onTheTravelRequestsList: TravelRequestsList,
			onTheTravelRequestsObjectPage: TravelRequestsObjectPage,
			onTheTravelDocumentsObjectPage: TravelDocumentsObjectPage
        },
        async: true
    });

    return runner;
});

