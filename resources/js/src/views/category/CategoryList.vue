<template>
  <div>
    <b-card>
      <table class="table table-bordered">
        <tr>
          <td class="text-center">เอกสารรับเข้า-ส่งออก</td>
          <td class="text-center">ปี {{bookCodeData.year}}</td>
          <td class="text-center">ลำดับปัจจุบัน {{bookCodeData.bookIn}}</td>
          <td class="text-center">
            <b-button
              variant="outline-success"
              alt="แก้ไข"
              title="แก้ไข"
              class="btn-icon btn-sm"
              @click="
                $router.push({
                  name: 'book-code-edit'
                })
              "
            >
              <feather-icon icon="EditIcon" style="margin-bottom: -2px" />
            </b-button>
          </td>
        </tr>
      </table>
    </b-card>
    <b-card>
      <b-row>
        <b-col cols="12" md="12">
          <b-button
            variant="success"
            class="mb-sm-0 mr-0"
            @click="$router.push({ name: 'category-add' })"
            :block="$store.getters['app/currentBreakPoint'] === 'xs'"
          >
            <feather-icon
              icon="PlusSquareIcon"
              size="16"
              class="align-middle mr-25 mb-25 text-white"
            />
            <span class="d-none d-sm-inline">เพิ่มข้อมูล</span>
          </b-button>
          <hr />
        </b-col>
      </b-row>

      <b-row>
        <b-col md="2" sm="4" class="my-1">
          <b-form-group class="mb-0">
            <label class="d-inline-block text-sm-left mr-50">Per page</label>
            <b-form-select
              id="perPageSelect"
              v-model="perPage"
              size="sm"
              :options="pageOptions"
              class="w-50"
            />
          </b-form-group>
        </b-col>
        <b-col md="4" sm="8" class="my-1">
          <b-form-group
            label="Sort"
            label-cols-sm="3"
            label-align-sm="right"
            label-size="sm"
            label-for="sortBySelect"
            class="mb-0"
          >
            <b-input-group size="sm">
              <b-form-select
                id="sortBySelect"
                v-model="sortBy"
                :options="sortOptions"
                class="w-75"
              >
                <template v-slot:first>
                  <option value="">-- none --</option>
                </template>
              </b-form-select>
              <b-form-select
                v-model="sortDesc"
                size="sm"
                :disabled="!sortBy"
                class="w-25"
              >
                <option :value="false">Asc</option>
                <option :value="true">Desc</option>
              </b-form-select>
            </b-input-group>
          </b-form-group>
        </b-col>
        <b-col md="6" class="my-1">
          <b-form-group
            label="Filter"
            label-cols-sm="3"
            label-align-sm="right"
            label-size="sm"
            label-for="filterInput"
            class="mb-0"
          >
            <b-input-group size="sm">
              <b-form-input
                id="filterInput"
                v-model="filter"
                type="search"
                placeholder="Type to Search"
              />
              <b-input-group-append>
                <b-button :disabled="!filter" @click="filter = ''">
                  Clear
                </b-button>
              </b-input-group-append>
            </b-input-group>
          </b-form-group>
        </b-col>

        <b-col cols="12">
          <!-- :sticky-header="true" -->
          <b-table
            striped
            bordered
            hover
            responsive
            :per-page="perPage"
            :current-page="currentPage"
            :items="items"
            :fields="visibleFields"
            :sort-by.sync="sortBy"
            :sort-desc.sync="sortDesc"
            :sort-direction="sortDirection"
            :filter="filter"
            :filter-included-fields="filterOn"
            @filtered="onFiltered"
          >
            <template #row-details="row">
              <b-card>
                <b-row class="mb-2">
                  <b-col md="4" class="mb-1">
                    <span class="font-weight-bolder">ข้อมูล :</span>
                    <span></span>
                  </b-col>
                </b-row>
                <b-button
                  size="sm"
                  variant="outline-secondary"
                  @click="row.toggleDetails"
                >
                  Hide
                </b-button>
              </b-card>
            </template>

            <template #cell(action)="row">
              <b-button
                variant="outline-success"
                alt="แก้ไข"
                title="แก้ไข"
                class="btn-icon btn-sm"
                @click="
                  $router.push({
                    name: 'category-edit',
                    params: { id: row.item.id },
                  })
                "
              >
                <feather-icon icon="EditIcon" style="margin-bottom: -2px" />
              </b-button>
              <b-button
                @click="onConfirmDelete(row.item.id)"
                variant="outline-danger"
                alt="ลบ"
                title="ลบ"
                class="btn-icon btn-sm"
              >
                <feather-icon icon="TrashIcon" style="margin-bottom: -2px" />
              </b-button>
            </template>
          </b-table>
        </b-col>

        <b-col cols="12">
          <b-pagination
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="perPage"
            align="center"
            size="sm"
            class="my-0"
          />
        </b-col>
      </b-row>
    </b-card>
  </div>
</template>

<script>
import {
  BTable,
  BAvatar,
  BBadge,
  BRow,
  BCol,
  BFormGroup,
  BFormSelect,
  BPagination,
  BInputGroup,
  BFormInput,
  BInputGroupAppend,
  BButton,
  BCard,
  BForm,
  BFormRating,
} from "bootstrap-vue";

import store from "@/store";
import useCategoryList from "./useCategoryList";
import categoryStoreModule from "./categoryStoreModule";
import { onUnmounted } from "@vue/composition-api";

export default {
  components: {
    BTable,
    BAvatar,
    BBadge,
    BRow,
    BCol,
    BFormGroup,
    BFormSelect,
    BPagination,
    BInputGroup,
    BFormInput,
    BInputGroupAppend,
    BButton,
    BCard,
    BForm,
    BFormRating,
  },
  setup() {
    const CATEGORY_LIST_APP_STORE_MODULE_NAME = "category-list";

    // Register module
    if (!store.hasModule(CATEGORY_LIST_APP_STORE_MODULE_NAME))
      store.registerModule(
        CATEGORY_LIST_APP_STORE_MODULE_NAME,
        categoryStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(CATEGORY_LIST_APP_STORE_MODULE_NAME))
        store.unregisterModule(CATEGORY_LIST_APP_STORE_MODULE_NAME);
    });

    //

    const {
      items,
      perPage,
      pageOptions,
      totalRows,
      currentPage,
      sortBy,
      sortDesc,
      sortDirection,
      filter,
      filterOn,
      visibleFields,
      sortOptions,
      onFiltered,
      table,
      onConfirmDelete,
      bookCodeData
    } = useCategoryList();

    return {
      items,
      perPage,
      pageOptions,
      totalRows,
      currentPage,
      sortBy,
      sortDesc,
      sortDirection,
      filter,
      filterOn,
      visibleFields,
      sortOptions,
      onFiltered,
      table,
      onConfirmDelete,
      bookCodeData
    };
  },
};
</script>

<style lang="scss">
.table th,
.table td {
  padding: 0.75rem 1rem;
}

.mw-3-5 {
  padding: 0.75rem 0.2rem !important;
  min-width: 3.5rem !important;
}

.mw-3-7 {
  padding: 0.75rem 0.2rem !important;
  min-width: 3.7rem !important;
}

.mw-4 {
  padding: 0.75rem 0.2rem !important;
  min-width: 6rem !important;
}

.mw-8 {
  padding: 0.75rem 0.2rem !important;
  min-width: 8rem !important;
}

.mw-10 {
  padding: 0.75rem 0.2rem !important;
  min-width: 10rem !important;
}

@media only screen and (min-width: 1200px) {
  .mw-e-8 {
    padding: 0.75rem 0.2rem !important;
    min-width: 8rem !important;
  }
}
</style>
