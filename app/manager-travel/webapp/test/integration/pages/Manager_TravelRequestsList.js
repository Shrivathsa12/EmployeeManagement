sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'managertravel',
            componentId: 'Manager_TravelRequestsList',
            contextPath: '/Manager_TravelRequests'
        },
        CustomPageDefinitions
    );
});