sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"managertravel/test/integration/pages/Manager_TravelRequestsList",
	"managertravel/test/integration/pages/Manager_TravelRequestsObjectPage",
	"managertravel/test/integration/pages/TravelDocumentsObjectPage"
], function (JourneyRunner, Manager_TravelRequestsList, Manager_TravelRequestsObjectPage, TravelDocumentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('managertravel') + '/test/flp.html#app-preview',
        pages: {
			onTheManager_TravelRequestsList: Manager_TravelRequestsList,
			onTheManager_TravelRequestsObjectPage: Manager_TravelRequestsObjectPage,
			onTheTravelDocumentsObjectPage: TravelDocumentsObjectPage
        },
        async: true
    });

    return runner;
});

