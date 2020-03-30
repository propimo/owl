import $ from 'jquery'

function ajaxFormConstructor(successCallback, errorCallback) {
  return function(selector) {
    $(`${selector}`).on("ajax:success", function (event) {
      $('.help-block').hide().empty();

      successCallback(event);

      let edit_path = event.detail[0]['edit_path'];

      if (edit_path !== null && edit_path !== undefined) {
        window.history.replaceState({}, "", edit_path);
      }
    }).on("ajax:error", function (event) {
      $('.help-block').hide().empty();

      let data = event.detail[0];
      errorCallback(data);

      let errors = data['errors'];
      if (errors !== null && errors !== undefined) {

        let base_errors = errors['base'];
        if (base_errors !== null && base_errors !== undefined) {
          for (let key in base_errors) {
            errorCallback(base_errors[key]);
          }
        }

        for (let key in errors) {
          let elem_id = key.replace(/\./g, '_');
          $(`#${elem_id}`).show();

          errors[key].forEach(value => {
            $(`#${elem_id}`).append(`<div>${value}</div>`);
          });
        }
      }
    });
  }
}

export { ajaxFormConstructor }
