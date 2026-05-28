using {FinalTask as FT} from '../db/schema';

@requires: [
    'Employee',
    'Manager',
    'Administrator'
]
service LeaveManagementService {

    @requires: [
        'Employee',
        'Administrator'
    ]
    @restrict: [
        {
            grant: 'READ',
            to   : ['Employee']
        },
        {
            grant: '*',
            to   : ['Administrator']
        }
    ]
    entity Employees             as projection on FT.Employees
        actions {
            @requires: [
                'Employee',
                'Administrator'
            ]
            @restrict: [{
                grant: '*',
                to   : [
                    'Employee',
                    'Administrator'
                ]
            }, ]
            function getLeaveBalance() returns String;
        };

    @requires: [
        'Employee',
        'Administrator'
    ]
    @restrict: [
        {
            grant: 'READ',
            to   : ['Employee']
        },
        {
            grant: '*',
            to   : ['Administrator']
        }
    ]
    entity Departments           as projection on FT.Departments;

    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [

        {
            grant: [
                'READ',
                'CREATE',
                'UPDATE'
            ],
            to   : ['Employee']
        },
        {
            grant: '*',
            to   : ['Administrator']
        },

    ]
    @odata.draft.enabled
    entity LeaveRequests         as projection on FT.LeaveRequests
        actions {


            @requires: [
                'Employee',
                'Administrator'
            ]
            @restrict: [{
                grant: '*',
                to   : [
                    'Employee',
                    'Administrator'
                ]
            }, ]
            action submitLeaveRequest() returns String;

            @requires: [
                'Employee',
                'Administrator'
            ]
            @restrict: [{
                grant: '*',
                to   : [
                    'Employee',
                    'Administrator'
                ]
            }, ]
            action cancelLeave()        returns String;
        };

    @requires: [
        'Manager',
        'Administrator'
    ]
    @restrict: [
        {
            grant: 'READ',
            to   : ['Manager', ]
        },
        {
            grant: '*',
            to   : ['Administrator']
        }
    ]
    entity Manager_LeaveRequests as projection on FT.Manager_LeaveRequests
        actions {
            @requires: [
                'Manager',
                'Administrator'
            ]
            @restrict: [{
                grant: '*',
                to   : [
                    'Manager',
                    'Administrator'
                ]
            }, ]
            action approveLeave()              returns String;

            @requires: [
                'Manager',
                'Administrator'
            ]
            @restrict: [{
                grant: '*',
                to   : [
                    'Manager',
                    'Administrator'
                ]
            }, ]
            action rejectLeave(Reason: String) returns String;
        };

    @Aggregation.ApplySupported: {
        Transformations       : [
            'aggregate',
            'groupby'
        ],
        GroupableProperties   : [Status],
        AggregatableProperties: [{
            Property                   : TotalRequests,
            SupportedAggregationMethods: ['sum']
        }]
    }

    @requires                  : ['Administrator']
    @restrict                  : [{
        grant: 'READ',
        to   : ['Administrator']
    }]
    entity LeaveAnalytics        as projection on FT.LeaveAnalytics;

    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [{
        grant: 'READ',
        to   : [
            'Employee',
            'Manager',
            'Administrator'
        ]
    }]
    entity LeaveTypeView         as projection on FT.LeaveTypeView;

    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [{
        grant: 'READ',
        to   : [
            'Employee',
            'Manager',
            'Administrator'
        ]
    }]
    entity StatusTypeView        as projection on FT.StatusTypeView;

};


@requires: [
    'Employee',
    'Manager',
    'Administrator'
]
service TravelManagementService {


    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [

        {
            grant: [
                'READ',
                'CREATE',
                'UPDATE'
            ],
            to   : ['Employee']
        },

        {
            grant: [
                'READ',
                'DELETE'
            ],
            to   : ['Manager']
        },

        {
            grant: '*',
            to   : ['Administrator']
        },

    ]
    @cds.redirection.target
    entity TravelRequests          as projection on FT.TravelRequests
        actions {
            @Core.OperationAvailable: {$edmJson: {$Eq: [
                {$Path: 'Status'},
                'Approved'
            ]}}
            @requires               : [
                'Employee',
                'Administrator'
            ]
            @restrict               : [{
                grant: '*',
                to   : [
                    'Employee',
                    'Administrator'
                ]
            }, ]
            action completeTravel()                                 returns String;


            @Core.OperationAvailable: {$edmJson: {$Eq: [
                {$Path: 'Status'},
                'Completed'
            ]}}
            @requires               : [
                'Employee',
                'Administrator'
            ]
            @restrict               : [{
                grant: '*',
                to   : [
                    'Employee',
                    'Administrator'
                ]
            }, ]
            action updateActualBudget(ActualBudget: Decimal(10, 2)) returns Decimal(10, 2);
        };


    entity Manager_TravelRequests  as projection on FT.Manager_TravelRequests
        actions {
            @Core.OperationAvailable: {$edmJson: {$Eq: [
                {$Path: 'Status'},
                'Pending'
            ]}}
            @requires               : [
                'Manager',
                'Administrator'
            ]
            @restrict               : [{
                grant: '*',
                to   : [
                    'Manager',
                    'Administrator'
                ]
            }, ]
            action approveTravel()              returns String;

            @Core.OperationAvailable: {$edmJson: {$Eq: [
                {$Path: 'Status'},
                'Pending'
            ]}}
            @requires               : [
                'Manager',
                'Administrator'
            ]
            @restrict               : [{
                grant: '*',
                to   : [
                    'Manager',
                    'Administrator'
                ]
            }, ]
            action rejectTravel(Reason: String) returns String;
        };

    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [
        {
            grant: 'READ',
            to   : [
                'Employee',
                'Manager'
            ]
        },
        {
            grant: [
                'CREATE',
                'UPDATE'
            ],
            to   : ['Employee']
        },
        {
            grant: '*',
            to   : ['Administrator']
        },
    ]
    entity TravelDocuments         as projection on FT.TravelDocuments;

    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [{
        grant: 'READ',
        to   : [
            'Employee',
            'Manager',
            'Administrator'
        ]
    }]
    entity Employees               as projection on FT.Employees
                                      order by
                                          EmpNo asc;

    @requires: [
        'Employee',
        'Manager',
        'Administrator'
    ]
    @restrict: [{
        grant: 'READ',
        to   : [
            'Employee',
            'Manager',
            'Administrator'
        ]
    }]

    entity StatusTypeViewforTravel as projection on FT.StatusTypeViewforTravel;


}
