(window["webpackJsonp"] = window["webpackJsonp"] || []).push([[5],{

/***/ "./app/javascript/pages/Room/index.vue":
/*!*********************************************!*\
  !*** ./app/javascript/pages/Room/index.vue ***!
  \*********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _index_vue_vue_type_template_id_ed0ba082___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./index.vue?vue&type=template&id=ed0ba082& */ "./app/javascript/pages/Room/index.vue?vue&type=template&id=ed0ba082&");
/* harmony import */ var _index_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./index.vue?vue&type=script&lang=js& */ "./app/javascript/pages/Room/index.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _index_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _index_vue_vue_type_template_id_ed0ba082___WEBPACK_IMPORTED_MODULE_0__["render"],
  _index_vue_vue_type_template_id_ed0ba082___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/pages/Room/index.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/pages/Room/index.vue?vue&type=script&lang=js&":
/*!**********************************************************************!*\
  !*** ./app/javascript/pages/Room/index.vue?vue&type=script&lang=js& ***!
  \**********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_index_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./index.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/pages/Room/index.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_index_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/pages/Room/index.vue?vue&type=template&id=ed0ba082&":
/*!****************************************************************************!*\
  !*** ./app/javascript/pages/Room/index.vue?vue&type=template&id=ed0ba082& ***!
  \****************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_index_vue_vue_type_template_id_ed0ba082___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./index.vue?vue&type=template&id=ed0ba082& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/pages/Room/index.vue?vue&type=template&id=ed0ba082&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_index_vue_vue_type_template_id_ed0ba082___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_index_vue_vue_type_template_id_ed0ba082___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/pages/Room/index.vue?vue&type=script&lang=js&":
/*!******************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/pages/Room/index.vue?vue&type=script&lang=js& ***!
  \******************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/* harmony default export */ __webpack_exports__["default"] = ({
  data: function data() {
    return {
      room: [{
        name: 'ドミトリー１',
        stock_max: 10,
        overbooking_thresh: 8,
        price: 2700,
        status: 1
      }, {
        name: 'ファミリーA',
        stock_max: 3,
        overbooking_thresh: 2,
        price: 7000,
        status: 1
      }, {
        name: 'ファミリーB：ツイン',
        stock_max: 2,
        overbooking_thresh: 1,
        price: 10000,
        status: 1
      }]
    };
  },
  methods: {
    handleEdit: function handleEdit(index, row) {
      console.log(index, row);
    },
    handleDelete: function handleDelete(index, row) {
      console.log(index, row);
    }
  }
});

/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/pages/Room/index.vue?vue&type=template&id=ed0ba082&":
/*!**********************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/pages/Room/index.vue?vue&type=template&id=ed0ba082& ***!
  \**********************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c(
    "el-table",
    { staticStyle: { width: "100%" }, attrs: { data: _vm.room, stripe: "" } },
    [
      _c("el-table-column", {
        attrs: { prop: "name", label: "部屋名", width: "180" }
      }),
      _vm._v(" "),
      _c("el-table-column", {
        attrs: { prop: "stock_max", label: "部屋数", width: "180" }
      }),
      _vm._v(" "),
      _c("el-table-column", {
        attrs: { prop: "overbooking_thresh", label: "OB最大数" }
      }),
      _vm._v(" "),
      _c("el-table-column", { attrs: { prop: "price", label: "料金" } }),
      _vm._v(" "),
      _c("el-table-column", { attrs: { prop: "status", label: "状態" } }),
      _vm._v(" "),
      _c("el-table-column", {
        attrs: { label: "Operations" },
        scopedSlots: _vm._u([
          {
            key: "default",
            fn: function(scope) {
              return [
                _c(
                  "el-button",
                  {
                    attrs: { size: "mini" },
                    on: {
                      click: function($event) {
                        return _vm.handleEdit(scope.$index, scope.row)
                      }
                    }
                  },
                  [_vm._v("Edit")]
                ),
                _vm._v(" "),
                _c(
                  "el-button",
                  {
                    attrs: { size: "mini", type: "danger" },
                    on: {
                      click: function($event) {
                        return _vm.handleDelete(scope.$index, scope.row)
                      }
                    }
                  },
                  [_vm._v("Delete")]
                )
              ]
            }
          }
        ])
      })
    ],
    1
  )
}
var staticRenderFns = []
render._withStripped = true



/***/ })

}]);
//# sourceMappingURL=5-b098f99fabe8cfde8380.chunk.js.map