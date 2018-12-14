// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree ./FooterLoaders
(function($){
    'use strict';

    var demo = {
        init: function(){
            // Select2 dropdown
            demo.select2DropdownInit('.breadcrumb-wrapper select');

            // Daterangepicker
            // Function Arguments: selector
//                demo.dateRangePickerInit('.page-title-wrapper .btn');

            // Donut chart
            // Function Arguments: selector, data, color1, color2
            // Cards donut charts data
            var topSellerData = [
                { label : "$750,000", data: 75 },
                { label : "$250,000", data: 25 }
            ];

            var revenueData = [
                { label : "Actual", data: parseInt($(".sales-card").find('h2.sales-per').text()) },
                { label : "Target", data: 100 - parseInt($(".sales-card").find('h2.sales-per').text()) }
            ];

            var feedbackData = [
                { label : "$800,000", data: 80 },
                { label : "$200,000", data: 20 }
            ];

            var orderData = [
                { label : "$750,000", data: 75 },
                { label : "$250,000", data: 25 }
            ];

            demo.donutChartInit('#chart-donut-top-seller', topSellerData, '#51C2CF', '#F9B56A');
            demo.donutChartInit('#chart-donut-revenue', revenueData, '#51C2CF', '#F9B56A');
            demo.donutChartInit('#chart-donut-feedback', feedbackData, '#51C2CF', '#F9B56A');
            demo.donutChartInit('#chart-donut-order', orderData, '#51C2CF', '#F9B56A');

            // Line chart
            // Function Arguments: selector, data, label, color, fill color, point highlight color
            // Expenses data
            var expensesData = [
                [new Date(2016, 0, 1).getTime(),10],
                [new Date(2016, 1, 1).getTime(),15],
                [new Date(2016, 2, 1).getTime(),25],
                [new Date(2016, 3, 1).getTime(),5],
                [new Date(2016, 4, 1).getTime(),70],
                [new Date(2016, 5, 1).getTime(),95],
                [new Date(2016, 6, 1).getTime(),55],
                [new Date(2016, 7, 1).getTime(),10],
                [new Date(2016, 8, 1).getTime(),25],
                [new Date(2016, 9, 1).getTime(),50],
                [new Date(2016, 10, 1).getTime(),45],
                [new Date(2016, 11, 1).getTime(),15],
                [new Date(2016, 12, 1).getTime(),35]
            ];
            // Expenses chart
            demo.lineChartInit('#chart-expenses', expensesData, 'Expenses', 'rgb(255, 206, 153)', 'rgba(255, 206, 153, .5)', '#FDB05B');

            // Bar chart
            // Function Arguments: selector, data, label, color, fill color, highlight color
            // Refunds data
            var refundsData = [
                [new Date(2015, 0, 15).getTime(),1600],
                [new Date(2015, 0, 30).getTime(),1400],

                [new Date(2015, 1, 14).getTime(),1400],
                [new Date(2015, 1, 29).getTime(),2200],

                [new Date(2015, 2, 15).getTime(),9500],
                [new Date(2015, 2, 30).getTime(),8000],

                [new Date(2015, 3, 15).getTime(),5000],
                [new Date(2015, 3, 30).getTime(),4500],

                [new Date(2015, 4, 15).getTime(),3800],
                [new Date(2015, 4, 30).getTime(),4500],

                [new Date(2015, 5, 15).getTime(),4500],
                [new Date(2015, 5, 30).getTime(),6000],

                [new Date(2015, 6, 15).getTime(),4000],
                [new Date(2015, 6, 30).getTime(),5500],

                [new Date(2015, 7, 15).getTime(),6000],
                [new Date(2015, 7, 30).getTime(),7500],

                [new Date(2015, 8, 15).getTime(),7500],
                [new Date(2015, 8, 30).getTime(),6500],

                [new Date(2015, 9, 15).getTime(),8000],
                [new Date(2015, 9, 30).getTime(),7000],

                [new Date(2015, 10, 15).getTime(),6000],
                [new Date(2015, 10, 30).getTime(),7500],

                [new Date(2015, 11, 15).getTime(),7500],
                [new Date(2015, 11, 30).getTime(),6500],

                [new Date(2015, 12, 15).getTime(),8000],
                [new Date(2015, 12, 30).getTime(),7000]
            ];
            // Refunds chart
            // demo.barChartInit('#chart-refunds', refundsData, 'Refunds', '#73C2EA', '#92DBFF', '#93D4F4');

            // Pie chart
            // Function Arguments: selector
            demo.pieChartInit('.inline-sparkline');

            // Datatables
            //Setting default values
            $.extend( $.fn.dataTable.defaults,{
                dom: '<"table-responsive" <t>>', // Table
                autoWidth: false
            });

            // Sales stats table
            // Function Arguments: selector, options
            var salesOptions = { order: [[1, 'desc']] };
            demo.datatablesInit('.panel-country-sales .table', salesOptions);

            // Combined line chart
            // Function Arguments: selector, data1, label1, color1, data2, label2, color2
            // Users comparison data
            var usersData1 = [
                [new Date(2016, 0, 1).getTime(),0],
                [new Date(2016, 1, 1).getTime(),10],
                [new Date(2016, 2, 1).getTime(),17],
                [new Date(2016, 3, 1).getTime(),25],
                [new Date(2016, 4, 1).getTime(),10],
                [new Date(2016, 5, 1).getTime(),0],
                [new Date(2016, 6, 1).getTime(),80],
                [new Date(2016, 7, 1).getTime(),90],
                [new Date(2016, 8, 1).getTime(),55],
                [new Date(2016, 9, 1).getTime(),45],
                [new Date(2016, 10, 1).getTime(),30],
                [new Date(2016, 11, 1).getTime(),35],
                [new Date(2016, 12, 1).getTime(),25],
            ];
            var usersData2 = [
                [new Date(2016, 0, 1).getTime(),100],
                [new Date(2016, 1, 1).getTime(),0],
                [new Date(2016, 2, 1).getTime(),10],
                [new Date(2016, 3, 1).getTime(),35],
                [new Date(2016, 4, 1).getTime(),25],
                [new Date(2016, 5, 1).getTime(),40],
                [new Date(2016, 6, 1).getTime(),75],
                [new Date(2016, 7, 1).getTime(),15],
                [new Date(2016, 8, 1).getTime(),10],
                [new Date(2016, 9, 1).getTime(),25],
                [new Date(2016, 10, 1).getTime(),10],
                [new Date(2016, 11, 1).getTime(),20],
                [new Date(2016, 12, 1).getTime(),10],
            ];
            // Users comparison chart
            demo.lineChartCombinedInit('#chart-users', usersData1, 'RM Variance', '#5EBDEC', usersData2, 'Utilities Variance', '#4EC27F');

            // Easy pie chart
            // Function Arguments: selector
            demo.easyPieChartInit('.easy-pie-chart');

            // Task list
            // Function Arguments: selector
            demo.datatablesTasklistInit('.panel-tasks .table');

            // Lead staff
            // Function Arguments: selector
            demo.datatablesLeadStaffInit('.panel-lead-staff .table');

            // Calendar
            // Function Arguments: selector, events data
            // Events data
            var myDate = new Date();
            var currentYear = myDate.getFullYear();
            var currentMonth = myDate.getMonth() + 1;
            currentMonth = (currentMonth < 10) ? 0 + '' + currentMonth : currentMonth;
            var events = [
                {
                    title: 'All Day Event',
                    start: currentYear + '-' + currentMonth + '-01'
                },
                {
                    title: 'Long Event',
                    start: currentYear + '-' + currentMonth + '-07',
                    end: currentYear + '-' + currentMonth + '-10'
                },
                {
                    id: 999,
                    title: 'Repeating Event',
                    start: currentYear + '-' + currentMonth + '-09T16:00:00'
                },
                {
                    id: 999,
                    title: 'Repeating Event',
                    start: currentYear + '-' + currentMonth + '-16T16:00:00'
                },
                {
                    title: 'Conference',
                    start: currentYear + '-' + currentMonth + '-11',
                    end: currentYear + '-' + currentMonth + '-13'
                },
                {
                    title: 'Meeting',
                    start: currentYear + '-' + currentMonth + '-12T10:30:00',
                    end: currentYear + '-' + currentMonth + '-12T12:30:00'
                },
                {
                    title: 'Lunch',
                    start: currentYear + '-' + currentMonth + '-12T12:00:00'
                },
                {
                    title: 'Meeting',
                    start: currentYear + '-' + currentMonth + '-12T14:30:00'
                },
                {
                    title: 'Happy Hour',
                    start: currentYear + '-' + currentMonth + '-12T17:30:00'
                },
                {
                    title: 'Dinner',
                    start: currentYear + '-' + currentMonth + '-12T20:00:00'
                },
                {
                    title: 'Birthday Party',
                    start: currentYear + '-' + currentMonth + '-13T07:00:00'
                },
                {
                    title: 'Click for Google',
                    url: 'http://google.com/',
                    start: currentYear + '-' + currentMonth + '-28'
                }
            ]
            // Calendar
            demo.calendarInit('#calendar', events);

            // Event list
            // Function Arguments: selector
            demo.datatablesEventListInit('.panel-events .table');

            // Live search
            // Function Arguments: Selector, search input, parent selector, child selector
            demo.contentLiveSearchInit('.panel-activity-monitor', '#search-activity-monitor', '.media', 'div');
            demo.contentLiveSearchInit('.panel-chat', '#search-chat', '.media', 'div');

            // Custom scrollbar
            // Function Arguments: selector
            // demo.slimscrollInit('.panel-activity-monitor .media-wrapper');
            // demo.slimscrollInit('.panel-chat .media-wrapper');

            // Hide scrollbar when page is loaded
            $('.slimScrollBar').hide();
        },
        select2DropdownInit: function(el){
//                $(el).select2({
//                    theme: 'bootstrap',
//                    minimumResultsForSearch: Infinity
//                }).next('.select2-container--bootstrap').addClass('input-sm');
        },
        dateRangePickerInit: function(el){
            // Predefined ranges
            function drp(start, end) {
                $(el).find('span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
            }
            drp(moment().subtract(29, 'days'), moment());

            $(el).daterangepicker({
                applyClass: 'btn-primary',
                opens: 'left',
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                }
            }, drp);
        },
        slimscrollInit: function(el){
            // Gets max-height
            // var height = parseInt($(el).css('max-height'));
            //
            // $(el).slimScroll({
            //     height: height,
            //     allowPageScroll: true,
            //     color: '#000'
            // });
        },
        donutChartInit: function(el, data, color1, color2){
            $.plot(el, data, {
                series: {
                    pie: {
                        show: true,
                        innerRadius: 0.5,
                        label: {
                            show: false
                        }
                    }
                },
                legend: {
                    show: false,
                },
                grid: {
                    hoverable: true
                },
                colors: [color1, color2],
                tooltip: {
                    show: true,
                    content: "<span class='label' style='color: #fff; background-color: rgba(0,0,0,.6)'>%s</span>",
                    cssClass: "chart-tooltip",
                    defaultTheme: false
                }
            });
        },
        lineChartInit: function(el, data, label, color, fillColor, highlightColor){
            $.plot(el,
                [{
                    data: data,
                    label: label,
                    color: color,
                    shadowSize: 0
                }],
                {
                    series: {
                        lines: {
                            show: true,
                            fill: true,
                            fillColor: fillColor
                        },
                        points: {
                            symbol: function cross(ctx, x, y, radius, shadow){
                                ctx.arc(x, y, 4, 0, Math.PI*2, true);
                                ctx.fillStyle = ctx.strokeStyle;
                                ctx.lineWidth = 1;
                                ctx.fill();
                            }
                        }
                    },
                    xaxis: {
                        tickColor: "transparent",
                        mode: "time",
                        timeformat: "%b %Y"
                    },
                    yaxis: {
                        tickColor: "#f2f2f2",
                        max: 100
                    },
                    legend: {
                        margin: [5, 10],
                        labelBoxBorderColor: color,
                        labelFormatter: function(label, series) {
                            // series is the series object for the label
                            return "<span class='m-left-5'>"+label+"</span>";
                        }
                    },
                    grid: {
                        hoverable: true,
                        borderWidth: 1,
                        borderColor: "#f2f2f2"
                    },
                    highlightColor: highlightColor,
                    tooltip: {
                        show: true,
                        content: "<span class='label' style='color: #fff; background-color: rgba(0,0,0,.6)'>%x = %y</span>",
                        shifts: {
                            x: -45
                        },
                        cssClass: "chart-tooltip",
                        defaultTheme: false
                    }
                }
            );
        },
        barChartInit: function(el, data, label, color, fillColor, highlightColor){
            $.plot(el, [
                {
                    data: data,
                    label: label,
                    color: color
                }
            ], {
                series: {
                    bars: {
                        show: true,
                        barWidth: 24*15*60*60*600,
                        lineWidth: 1,
                        fill: 0.8,
                        fillColor: fillColor
                    }
                },
                xaxis: {
                    tickColor: "transparent",
                    mode: "time",
                    timeformat: "%b %Y"
                },
                yaxis: {
                    tickColor: "#f2f2f2",
                    max: 100
                },
                legend: {
                    margin: [5, 10],
                    labelBoxBorderColor: color,
                    labelFormatter: function(label, series) {
                        // series is the series object for the label
                        return "<span class='m-left-5'>"+label+"</span>";
                    }
                },
                grid: {
                    hoverable: true,
                    borderWidth: 1,
                    borderColor: "#f2f2f2"
                },
                highlightColor: highlightColor,
                tooltip: {
                    show: true,
                    content: "<span class='label' style='color: #fff; background-color: rgba(0,0,0,.6)'>%x = %y</span>",
                    cssClass: "chart-tooltip",
                    defaultTheme: false
                }
            });
        },
        pieChartInit: function(el){
            $(el).sparkline('html',{
                type: 'pie',
                width: '50',
                height: '50',
                offset: '90',
                sliceColors: ['#51c2cf','#F9B56A','#949fb2','#474F60','#EE6567']
            });
        },
        lineChartCombinedInit: function(el, data1, label1, color1, data2, label2, color2){
            $.plot(el,
                [{
                    data: data1,
                    label: label1,
                    color: color1,
                    shadowSize: 0,
                    highlightColor: color1
                },
                    {
                        data: data2,
                        label: label2,
                        color: color2,
                        shadowSize: 0,
                        highlightColor: color2
                    }],
                {
                    series: {
                        lines: {
                            show: true
                        },

                        points: {
                            symbol: function circle(ctx, x, y, radius, shadow){
                                ctx.arc(x, y, 4, 0, Math.PI*2, true);
                                ctx.fillStyle = ctx.strokeStyle;
                                ctx.lineWidth = 1;
                                ctx.fill();
                            }
                        }
                    },
                    xaxis: {
                        tickColor: "transparent",
                        mode: "time",
                        timeformat: "%b %Y"
                    },
                    yaxis: {
                        tickColor: "#f2f2f2",
                        max: 100
                    },
                    legend: {
                        margin: [5, 10],
                        labelBoxBorderColor: "#f6f6f6",
                        labelFormatter: function(label, series) {
                            // series is the series object for the label
                            return "<span class='m-left-5'>"+label+"</span>";
                        }
                    },
                    grid: {
                        hoverable: true,
                        borderWidth: 1,
                        borderColor: "#f2f2f2"
                    },
                    tooltip: {
                        show: true,
                        content: "<span class='label' style='color: #fff; background-color: rgba(0,0,0,.6)'>%x = %y</span>",
                        shifts: {
                            x: -45
                        },
                        cssClass: "chart-tooltip",
                        defaultTheme: false
                    }
                }
            );
        },
        easyPieChartInit: function(el){
            $(el).easyPieChart({
                onStep: function(from, to, percent){
                    $(this.el).find('.percent').text(Math.round(percent))
                }
            });
        },
        icheckInit: function(el){
            $(el).iCheck({
                checkboxClass: 'icheckbox_minimal-grey',
                radioClass: 'iradio_minimal-grey'
            });
        },
        datatablesIcheckChecked: function(){
            var thCheckbox = $(this).closest('th');
            var tdCheckbox = $(this).closest('.table').find('tbody input.icheck');

            if(thCheckbox.length)
                tdCheckbox.iCheck('check');
        },
        datatablesIcheckUnchecked: function(){
            var thCheckbox = $(this).closest('th');
            var tdCheckbox = $(this).closest('.table').find('tbody input.icheck');

            if(thCheckbox.length)
                tdCheckbox.iCheck('uncheck');
        },
        datatablesTasklistChildRow: function(el){
            // Dropdown table with extra info
            function tasksFormat(d){
                // `d` is the original data object for the row
                return  '<table class="table table-bordered">'+
                    '<tr>'+
                    '<td style="width: 35%;">Parent Project:</td>'+
                    '<td>'+d.parentProject+'</td>'+
                    '</tr>'+
                    '<tr>'+
                    '<td>Description:</td>'+
                    '<td>'+d.description+'</td>'+
                    '</tr>'+
                    '<tr>'+
                    '<td>Due Date:</td>'+
                    '<td>'+d.dueDate+'</td>'+
                    '</tr>'+
                    '<tr>'+
                    '<td>Assigned to:</td>'+
                    '<td>'+d.assign+'</td>'+
                    '</tr>'+
                    '</table>';
            }

            var tr = $(this).closest('tr');
            var row = el.DataTable().row(tr);

            if (row.child.isShown()){
                // This row is already open - close it
                row.child.hide();
                tr.removeClass('shown');
            }else{
                // Open this row
                row.child( tasksFormat(row.data())).show();
                tr.addClass('shown');
            }
        },
        datatablesTasklistEdit: function(el){
            $(this).removeClass('btn-edit').addClass('btn-save').find('.fa-pencil').removeClass("fa-pencil").addClass('fa-save');

            var tr = $(this).closest('tr');
            var td = tr.find('td');

            for(var i = 1; i <= td.length - 2; i++){
                var cellCur = $(el).DataTable().cell(td.eq(i));
                cellCur.data('<input type="text" class="form-control input-sm" value="'+cellCur.data()+'">');
            }
        },
        datatablesTasklistSave: function(el){
            $(this).removeClass('btn-save').addClass('btn-edit').find('.fa-save').removeClass("fa-save").addClass('fa-pencil');

            var tr = $(this).closest('tr');
            var td = tr.find('td');

            for(var i = 1; i <= td.length - 2; i++){
                var cellCur = $(el).DataTable().cell(td.eq(i));
                var inputVal = td.eq(i).find('.form-control').val();
                cellCur.data(inputVal).draw();
            }
        },
        datatablesTasklistRemove: function(el){
            $(el).DataTable().row().remove().draw(false);
        },
        datatablesTasklistInit: function(el){
            $(el).DataTable({
                dom:  '<f>'+ // Top section structure(search etc.)
                '<"table-responsive" <t>>', // Table
                language: {
                    search: '_INPUT_',
                    searchPlaceholder: 'Search...'
                },
                order: [ [1, 'asc'] ],
                columnDefs:[{
                    targets: [0,3],
                    orderable: false
                }],
                ajax: 'task-list-data.txt',
                columns: [
                    {
                        className: 'details-control',
                        defaultContent: "<input type='checkbox' class='icheck' autocomplete='off'>"
                    },
                    { data:  'title'},
                    { data: 'tag' },
                    { defaultContent: '<td>'+
                    '<div class="btn-group btn-group-xs pull-right">'+
                    '<button type="button" class="btn btn-default btn-edit">'+
                    '<i class="fa fa-pencil"></i>'+
                    '</button>'+
                    '<button type="button" class="btn btn-default btn-remove">'+
                    '<i class="fa fa-trash"></i>'+
                    '</button>'+
                    '</div></td>' }
                ],
                initComplete: function(settings, json){
                    // After getting data inits iCheck
                    demo.icheckInit('input.icheck');

                    // If checkbox in <th> is checked, marking checked all checkboxes too
                    $('.icheck').on('ifChecked', demo.datatablesIcheckChecked);

                    // If checkbox in <th> is unchecked, marking unchecked all checkboxes too
                    $('.icheck').on('ifUnchecked', demo.datatablesIcheckUnchecked);

                    // Add event listener for opening and closing details
                    $(el).find('tbody').on('click', 'td.details-control', $.proxy(demo.datatablesTasklistChildRow, null, $(el)));

                    // Editing, saving and removing
                    $(el).DataTable().on('click','.btn-edit', $.proxy(demo.datatablesTasklistEdit, null, el));

                    $(el).DataTable().on('click','.btn-save', $.proxy(demo.datatablesTasklistSave, null, el));

                    $(el).DataTable().on('click','.btn-remove', $.proxy(demo.datatablesTasklistRemove, null, el));
                }
            });
        },
        datatablesLeadStaffInit: function(el){
            $(el).DataTable({
                dom:  '<f>'+ // Top section structure(search etc.)
                '<"table-responsive" <t>>', // Table
                language: {
                    search: '_INPUT_',
                    searchPlaceholder: 'Search...'
                },
                order: [1, 'desc'],
                columnDefs:[{
                    targets: 2,
                    orderable: false
                }],
            });
        },
        datatablesInit: function(el, options){
            $(el).dataTable(options);
        },
        contentLiveSearchInit: function(container, searchField, selector, childSelector){
            $(container).searchable({
                searchField: searchField,
                selector: selector,
                childSelector: childSelector
            })
        },
        calendarInit: function(el, events){
            $(el).fullCalendar({
                header: {
                    left: "prev,next,title",
                    right: "today,month,agendaWeek,agendaDay"
                },
                buttonText: {
                    today: 'Today',
                    month: 'Month',
                    week:  'Week',
                    day:   'Day'
                },
                editable: true,
                eventLimit: true, // allow "more" link when too many events
                events: events
            });
        },
        datatablesEventListChildRow: function(el){
            // Dropdown table with extra info
            function eventsFormat(d){
                // `d` is the original data object for the row
                return  '<table class="table table-bordered">'+
                    '<tr>'+
                    '<td>Description:</td>'+
                    '<td>'+d.description+'</td>'+
                    '</tr>'+
                    '<tr>'+
                    '<td>Invited:</td>'+
                    '<td>'+d.invited+'</td>'+
                    '</tr>'+
                    '</table>';
            }

            var tr = $(this).closest('tr');
            var row = el.DataTable().row(tr);

            if (row.child.isShown()){
                // This row is already open - close it
                row.child.hide();
                tr.removeClass('shown');
            }else{
                // Open this row
                row.child( eventsFormat(row.data())).show();
                tr.addClass('shown');
            }
        },
        datatablesEventListInit: function(el){
            $(el).DataTable({
                ordering: false,
                ajax: 'event-list-data.txt',
                columns: [
                    {
                        className: 'details-control',
                        render: function(data, type, full, meta){
                            // Showing 2 values in one column
                            return '<span class="block">'+full.title+'</span>'+'<span>'+full.date+'</span>';
                        }
                    },
                    { defaultContent: '<button class="btn btn-default-outline">Cancel</button>' }
                ],
                initComplete: function(settings, json){
                    // Add event listener for opening and closing details
                    $(el).find('tbody').on('click', 'td.details-control', $.proxy(demo.datatablesEventListChildRow, null, $(el)));
                }
            });
        }
    };

    // demo.init();
})(jQuery);