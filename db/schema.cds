namespace FinalTask;

using {
    cuid,
    managed
} from '@sap/cds/common';


entity Employees : cuid {
    EmpNo        : String(10)                 @mandatory;
    Name         : String(50)                 @mandatory;
    Email        : String(50)                 @mandatory
                                              @assert.format: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    Manager      : Association to Employees;
    HireDate     : Date;
    LeaveBalance : Decimal(10, 2) default 30;
    Department   : Association to Departments;
}

entity Departments : cuid {
    DeptCode    : String(10)     @mandatory;
    DeptName    : String(50)     @mandatory;
    BudgetLimit : Decimal(10, 2) @assert.range: [
        0,
        99999999.99
    ];

    Employees   : Composition of many Employees
                      on Employees.Department = $self;
}

entity LeaveRequests : cuid, managed {
    Employee     : Association to Employees     ;
    LeaveType    : LeaveType                    @mandatory;
    StartDate    : Date                         @mandatory;
    EndDate      : Date                         @mandatory;

    NumberOfDays : Decimal(10, 2)               @readonly
                                                @assert.range: [
        0.5,
        365
    ];
    Status       : StatusType default 'Pending' @readonly;
    Reason       : String(255)                  @mandatory;
    ApprovedBy   : Association to Employees default null;
    ApprovalDate : Date;
}

entity TravelRequests : cuid, managed {
    Employee        : Association to Employees     @mandatory;
    Destination     : String(100)                  @mandatory;
    Purpose         : String(255)                  @mandatory;
    DepartureDate   : Date                         @mandatory;
    ReturnDate      : Date                         @mandatory;
    EstimatedBudget : Decimal(10, 2) default 00    @mandatory
                                                   @assert.range: [
        1000,
        99999999999
    ];
    ActualBudget    : Decimal(10, 2) default 00
                                                   @assert.range: [
        0,
        99999999999,

    ];
    Status          : StatusType default 'Pending' @readonly;
    Approver        : Association to Employees default null @readonly;
    ApprovalDate    : Date;
    Documents       : Composition of many TravelDocuments
                          on Documents.TravelRequest = $self;
}

entity TravelDocuments : cuid {
    TravelRequest : Association to TravelRequests       @mandatory;
    FileName      : String(255)                         @mandatory;
    FileURL       : LargeBinary                         @Core.MediaType  @Core.ContentDisposition: {
        FileName: FileName,
        Type    : 'attachment',
    };
    UploadedOn    : Timestamp default current_timestamp @readonly;
    FileSize      : Integer                             @assert.range: [
        1,
        10485760
    ];
}


type LeaveType  : String enum {
    Annual;
    Sick;
    Casual;
    Maternity
}

type StatusType : String enum {
    Pending;
    Approved;
    Rejected;
    Cancelled;
    Completed
}

entity Manager_LeaveRequests as select from LeaveRequests;
entity Manager_TravelRequests as select from TravelRequests;

entity LeaveTypeView         as
    select from LeaveRequests {
        key LeaveType
    }
    group by
        LeaveType;

entity StatusTypeView        as
    select from LeaveRequests {
        key Status
    }
    group by
        Status;

        entity StatusTypeViewforTravel        as
    select from TravelRequests {
        key Status
    }
    group by
        Status;

entity LeaveAnalytics        as
    select from LeaveRequests {
        key Status,
            count(ID) as TotalRequests : Integer
    }
    group by
        Status;
