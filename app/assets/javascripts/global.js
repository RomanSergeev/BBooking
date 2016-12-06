/**
 * Created by roman on 07.11.16.
 */

/**
 * @see CalendarsService::TIMELINE_PERCENT
 * @type {number}
 */
var TIMELINE_PERCENT = 14.4;

$(document).ready(function() {
  $('[data-toggle="popover"]').popover();

  var two_side_updater = [
    function (elems) {
      return function () {
        elems[1].value = elems[0].value;
      }
    },
    function (elems) {
      return function () {
        elems[0].value = elems[1].value;
      }
    }
  ];
  bind_updater([
    by_id('service\\[servicedata\\]\\[rest_time\\]'),
    by_id('restDoubler')
  ], two_side_updater);
  bind_updater([
    by_id('service\\[servicedata\\]\\[duration\\]'),
    by_id('rangeDoubler')
  ], two_side_updater);
  bind_updater([
    by_id('calendar\\[preferences\\]\\[rest_time\\]'),
    by_id('restTimeDoubler')
  ], two_side_updater);
  bind_updater([
    by_id('bookAtHours'),
    by_id('bookAtMinutes'),
    by_id('calendar-runner')
  ], [
    function(elems) {
      return function() {
        elems[2].style.left = calculate_left_offset(int(elems[0].value), int(elems[1].value)) + '%';
      }
    },
    function(elems) {
      return function() {
        elems[2].style.left = calculate_left_offset(int(elems[0].value), int(elems[1].value)) + '%';
      }
    },
    function(elems) {
      return function() {}
    }
  ]);
  var time_inputs_updater = [
    function (elems) {
      return function () {
        elems[1].value = Math.floor(elems[0].value / 60);
        elems[2].value = elems[0].value % 60;
      }
    },
    function (elems) {
      return function () {
        elems[0].value = int(elems[1].value) * 60 + int(elems[2].value);
      }
    },
    function (elems) {
      return function () {
        elems[0].value = int(elems[1].value) * 60 + int(elems[2].value);
      }
    }
  ];
  var headInputs = [
    by_id('calendar\\[preferences\\]\\[serving_start\\]'),
    by_id('calendar\\[preferences\\]\\[break_start\\]'),
    by_id('calendar\\[preferences\\]\\[break_finish\\]'),
    by_id('calendar\\[preferences\\]\\[serving_finish\\]')
  ];
  var groups = [
    [headInputs[0], by_id('startDoublerHours'), by_id('startDoublerMinutes')],
    [headInputs[1], by_id('breakStartDoublerHours'), by_id('breakStartDoublerMinutes')],
    [headInputs[2], by_id('breakFinishDoublerHours'), by_id('breakFinishDoublerMinutes')],
    [headInputs[3], by_id('finishDoublerHours'), by_id('finishDoublerMinutes')]
  ];
  for (var i = 0; i < groups.length; i++) {
    bind_updater(groups[i], time_inputs_updater);
  }
  // FIXME changing 'doubler' values doesn't affect other inputs
  for (i = 0; i < headInputs.length; i++) {
    if (!headInputs[i]) return;
    headInputs[i].addEventListener('input', function (j) {
      return function() {
        for (var k = 0; k < headInputs.length; k++) {
          if (k < j && int(headInputs[k].value) > int(headInputs[j].value) ||
              k > j && int(headInputs[k].value) < int(headInputs[j].value)) {
            headInputs[k].value = headInputs[j].value;
            prepareAndFireEvent(headInputs[k]);
          }
        }
      }
    }(i));
  }
});

function calculate_left_offset(hours, minutes) {
  return (hours * 60 + minutes) / TIMELINE_PERCENT;
}

function disable_rest_time_inputs(elem) {
  by_id('service\\[servicedata\\]\\[rest_time\\]').disabled =
  by_id('restDoubler').disabled =
  elem.checked;
}

function prepareAndFireEvent(elem) {
  var event = document.createEvent("HTMLEvents");
  event.initEvent("input", true, true);
  event.eventName = "input";
  elem.dispatchEvent(event);
}

function int(value) {
  return parseInt(value);
}

function by_id(id) {
  return $('#' + id)[0];
}

function bind_updater(elems, functions) {
  if (!elems[0]) return;
  var current_values = {}, i;
  for (i = 0; i < elems.length; i++) {
    current_values[i] = elems[i].value;
  }
  for (i = 0; i < elems.length; i++) {
    elems[i].addEventListener('input', functions[i](elems));
  }
}