$(document).ready(function(){
  get_status_interval     = 60000;
  remove_status_interval  = 15000;

  all_bot_status          = $('[name=bot_status]');
  all_bot_btn             = $('[name=bot_btn]');
  run_all_btn             = $('#run_all_btn');
  stop_all_btn            = $('#stop_all_btn');
});

function get_status() {
  $.ajax({
      type: 'POST',
      url: '/check_status',
      async: true,
      cache: false,

      data: { user_id : user_id },
      dataType: 'json',

      success: function(result){
        status_clear_all();

        for(var bot_id in result){
          if (result.hasOwnProperty(bot_id)){
            if (result[bot_id]['status'] == 'error') {
              setTimeout('status_clear(' + bot_id + ')', remove_status_interval);
              status_set_error(bot_id, result[bot_id]['message']);
            } else if (result[bot_id]['status'] == 'warning') {
              status_set_warning(bot_id, result[bot_id]['message']);
            } else {
              status_set_running(bot_id, result[bot_id]['message']);
            }
          }
        }
      }
  });
}

function status_clear_all() {
  var regexp      = /bot_(\d+)_btn/;

  all_bot_status.text('N/A');
  all_bot_status.removeClass('label-success label-important label-warning label-info label-inverse');

  all_bot_btn.removeClass('btn-danger btn-success').addClass('btn-success');
  all_bot_btn.text('Run');

  all_bot_btn.each(function () {
    bot_id = $(this).context.id.match(regexp, "$1");
    $('#bot_' + bot_id[1] + '_btn').attr('onclick', 'run(' + bot_id[1] + '); return false;');
  });
}

function status_clear(id) {
  change_status(id, 'N/A', 'N/A', '', 'btn-success', 'Run', 'run(' + id + '); return false;');
}

function status_set_running(id, message) {
  change_status(id, message, 'running', 'label-success', 'btn-danger', 'Stop', 'stop(' + id + '); return false;');
}

function status_set_warning(id, message) {
  change_status(id, message, 'warning', 'label-warning', 'btn-danger', 'Stop', 'stop(' + id + '); return false;');
}

function status_set_error(id, message) {
  change_status(id, message, 'error', 'label-important', 'btn-success', 'Run', 'run(' + id + '); return false;');
}

function status_set_info(id, message) {
  change_status(id, message, '---', 'label-info', 'btn-danger', 'Stop', 'stop(' + id + '); return false;');
}

function status_set_inverse(id, message) {
  change_status(id, message, 'sent', 'label-inverse', 'btn-success', 'Run', 'run(' + id + '); return false;');
}

function change_status(id, message, default_message, label_class, btn_class, btn_text, btn_function) {
  var bot_status  = $('#status_' + id);
  var bot_btn     = $('#bot_' + id + '_btn');

  bot_status.text(message == null ? default_message : message);
  bot_status.removeClass('label-success label-important label-warning label-info label-inverse').addClass(label_class);

  bot_btn.removeClass('btn-danger btn-success').addClass(btn_class);
  bot_btn.text(btn_text);
  bot_btn.attr('onclick', btn_function);
}

function change_bot_status(id, data) {
  var bot_btn = $('#bot_' + id + '_btn');

  if (data.status == 'ok') {
    status_set_running(id, data.message);
    bot_btn.removeClass('disabled');
  } else if (data.status == 'info') {
    status_set_info(id, data.message);
    bot_btn.removeClass('disabled');
  } else if (data.status == 'warning') {
    status_set_warning(id, data.message);
    bot_btn.removeClass('disabled');
  } else if (data.status == 'sent') {
    setTimeout('status_clear(' + id + ')', remove_status_interval);
    status_set_inverse(id, 'sent: ' + data.message);
    bot_btn.removeClass('disabled');
  } else {
    setTimeout('status_clear(' + id + ')', remove_status_interval);
    status_set_error(id, data.message)
    bot_btn.removeClass('disabled');
  }
}

function run(id) {
  var bot_btn = $('#bot_' + id + '_btn');

  status_clear(id);
  lock_action_all_btn(false);

  bot_btn.addClass('disabled');
  bot_btn.attr('onclick', 'return false;');

  $.ajax({
      type: 'POST',
      url: '/run',
      async: true,
      cache: false,

      data: { id : id },
      dataType: 'json',

      success: function(result){
        if (result.page_title != undefined && result.page_title != '') {
          $('#link_title_' + id).text(result.page_title);
        }

        change_bot_status(id, result);
        if ($('[name=bot_btn].disabled').length == 0) {
          unlock_action_all_btn();
        }
      }
  });
}

function stop(id) {
  var bot_btn = $('#bot_' + id + '_btn');

  status_clear(id);
  lock_action_all_btn(false);

  bot_btn.addClass('disabled');
  bot_btn.attr('onclick', 'return false;');

  $.ajax({
      type: 'POST',
      url: '/stop',
      async: true,
      cache: false,

      data: { id : id },
      dataType: 'json',

      success: function(result){
        change_bot_status(id, result);
        if ($('[name=bot_btn].disabled').length == 0) {
          unlock_action_all_btn();
        }
      }
  });
}

function run_all() {
  status_clear_all();
  lock_action_all_btn(true);

  $.ajax({
      type: 'POST',
      url: '/run_all',
      async: true,
      cache: false,

      data: { user_id : user_id },
      dataType: 'json',

      success: function(result){
        status_clear_all();

        if (result.statuses != undefined) {
          for(var bot_id in result.statuses){
            if (result.statuses.hasOwnProperty(bot_id)){
              change_bot_status(bot_id, result.statuses[bot_id]);
            }
          }
        }

        unlock_action_all_btn();
      }
  });
}

function stop_all() {
  lock_action_all_btn(true);

  $.ajax({
      type: 'POST',
      url: '/stop_all',
      async: true,
      cache: false,

      data: { user_id : user_id },
      dataType: 'json',

      success: function(result){
        status_clear_all();

        unlock_action_all_btn();
        all_bot_btn.removeClass('disabled');
      }
  });
}

function lock_action_all_btn(lock_all_bot_btn) {
  if (lock_all_bot_btn) {
    all_bot_btn.addClass('disabled');
    all_bot_btn.attr('onclick', 'return false;');
  }

  run_all_btn.addClass('disabled');
  run_all_btn.attr('onclick', 'return false;');

  stop_all_btn.addClass('disabled');
  stop_all_btn.attr('onclick', 'return false;');
}

function unlock_action_all_btn() {
  run_all_btn.removeClass('disabled');
  run_all_btn.attr('onclick', 'run_all(); return false;');

  stop_all_btn.removeClass('disabled');
  stop_all_btn.attr('onclick', 'stop_all(); return false;');
}