/**
 * Created by roman on 07.11.16.
 */

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
    $('#service\\[servicedata\\]\\[duration\\]')[0],
    $('#rangeDoubler')[0]
  ], two_side_updater);
  bind_updater([
    $('#calendar\\[preferences\\]\\[rest_time\\]')[0],
    $('#restTimeDoubler')[0]
  ], two_side_updater);
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
    $('#calendar\\[preferences\\]\\[serving_start\\]')[0],
    $('#calendar\\[preferences\\]\\[break_start\\]')[0],
    $('#calendar\\[preferences\\]\\[break_finish\\]')[0],
    $('#calendar\\[preferences\\]\\[serving_finish\\]')[0]
  ];
  var groups = [
    [headInputs[0], $('#startDoublerHours')[0], $('#startDoublerMinutes')[0]],
    [headInputs[1], $('#breakStartDoublerHours')[0], $('#breakStartDoublerMinutes')[0]],
    [headInputs[2], $('#breakFinishDoublerHours')[0], $('#breakFinishDoublerMinutes')[0]],
    [headInputs[3], $('#finishDoublerHours')[0], $('#finishDoublerMinutes')[0]]
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

function prepareAndFireEvent(elem) {
  var event = document.createEvent("HTMLEvents");
  event.initEvent("input", true, true);
  event.eventName = "input";
  elem.dispatchEvent(event);
}

function int(value) {
  return parseInt(value);
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