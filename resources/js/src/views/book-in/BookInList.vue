<template>
    <div>
        <b-modal
            id="modal-center"
            cancel-variant="outline-secondary"
            ok-title="Submit"
            cancel-title="Close"
            centered
            title="Export Form"
        >
            <b-form>
                <b-form-group>
                    <label for="start">วันที่เริ่ม:</label>
                    <flat-pickr
                        v-model="exportDate.start"
                        class="form-control"
                        placeholder="วันที่เริ่ม"
                        :config="configDate"
                    />
                </b-form-group>
                <b-form-group>
                    <label for="password">ถึงวันที่:</label>
                    <flat-pickr
                        v-model="exportDate.end"
                        class="form-control"
                        placeholder="ถึงวันที่"
                        :config="configDate"
                    />
                </b-form-group>
            </b-form>
            <template #modal-footer="{ cancel }">
                <b-button variant="success" @click="onExportExcel">
                    Submit
                </b-button>
                <b-button variant="danger" @click="cancel()"> Cancel </b-button>
            </template>
        </b-modal>

        <b-card>
            <b-row>
                <!-- Contact -->
                <b-col md="12">
                    <h4>ค้นหา</h4>
                    <hr />
                </b-col>
                <b-col md="4">
                    <b-form-group label="ประเภทเอกสาร" label-for="">
                        <v-select
                            v-model="advancedSearch.categoryName"
                            :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                            label="title"
                            :clearable="false"
                            placeholder="-- ประเภทเอกสาร --"
                            :options="selectOptions.category"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="4">
                    <b-form-group label="เลขที่" label-for="">
                        <b-form-input
                            id="bookFromNo"
                            v-model="advancedSearch.bookFromNo"
                            placeholder="เลขที่เอกสาร (จากต้นทาง)"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="4">
                    <b-form-group label="ลงวันที่" label-for="">
                        <flat-pickr
                            v-model="advancedSearch.bookFromDate"
                            placeholder="ลงวันที่ (จากต้นทาง)"
                            class="form-control"
                            :config="configDate"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="6">
                    <b-form-group label="เรื่อง" label-for="">
                        <b-form-input
                            id="title"
                            v-model="advancedSearch.title"
                            placeholder="ชื่อเรื่อง"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="6">
                    <b-form-group label="ฝ่ายที่เกี่ยวข้อง" label-for="">
                        <v-select
                            v-model="advancedSearch.departmentName"
                            :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                            label="title"
                            placeholder="-- หน่วยงาน --"
                            :clearable="false"
                            :options="selectOptions.department"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="6">
                    <b-form-group label="หน่วยงาน (ต้นทาง)" label-for="">
                        <b-form-input
                            id="bookFrom"
                            v-model="advancedSearch.bookFrom"
                            placeholder="หน่วยงาน (ต้นทาง)"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="6">
                    <b-form-group label="ผู้รับ" label-for="">
                        <b-form-input
                            id="toSend"
                            v-model="advancedSearch.toSend"
                            placeholder="ผู้รับ"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="3">
                    <b-form-group label="เลขรับ" label-for="">
                        <b-form-input
                            id="bookNo"
                            v-model="advancedSearch.bookNo"
                            placeholder="เลขที่รับ"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="3">
                    <b-form-group label="วันที่รับ" label-for="">
                        <flat-pickr
                            v-model="advancedSearch.dateReceive"
                            class="form-control"
                            placeholder="วันที่ลงรับ"
                            :config="configDate"
                        />
                    </b-form-group>
                </b-col>

                <!-- <b-col md="4">
          <b-form-group label="Favorite" label-for="">
            <v-select
              v-model="advancedSearch.favorite"
              label="title"
              :clearable="false"
              placeholder="-- Favorite --"
              :options="selectOptions.favorite"
            />
          </b-form-group>
        </b-col> -->
            </b-row>
        </b-card>

        <b-card>
            <b-row>
                <b-col cols="12" md="12">
                    <b-button
                        v-if="showBtnAdmin"
                        variant="success"
                        class="mb-sm-0 mr-0"
                        @click="$router.push({ name: 'bookin-add' })"
                        :block="
                            $store.getters['app/currentBreakPoint'] === 'xs'
                        "
                    >
                        <feather-icon
                            icon="PlusSquareIcon"
                            size="16"
                            class="align-middle mr-25 mb-25 text-white"
                        />
                        <span class="d-none d-sm-inline">สร้างเอกสาร</span>
                    </b-button>

                    <!-- FREEDOM -->

                    <!-- @click="$router.push({ name: 'bookin-add' })" -->
                    <b-button
                        v-if="showBtnAdmin"
                        variant="warning"
                        class="mb-sm-0 mr-0"
                        :block="
                            $store.getters['app/currentBreakPoint'] === 'xs'
                        "
                        v-ripple.400="'rgba(113, 102, 240, 0.15)'"
                        v-b-modal.modal-center
                    >
                        <feather-icon
                            icon="FileIcon"
                            size="16"
                            class="align-middle mr-25 mb-25 text-white"
                        />
                        <span class="d-none d-sm-inline"
                            >พิมพ์ตารางรับเอกสาร</span
                        >
                    </b-button>

                    <b-button
                        variant="info"
                        class="mb-sm-0 mr-0"
                        style="float: right"
                        @click="$router.push({ name: 'bookin-old' })"
                        :block="
                            $store.getters['app/currentBreakPoint'] === 'xs'
                        "
                    >
                        <feather-icon
                            icon="ArchiveIcon"
                            size="16"
                            title="ดูเอกสารย้อนหลัง"
                            alt="ดูเอกสารย้อนหลัง"
                            class="align-middle mr-25 mb-25 text-white"
                        />
                    </b-button>

                    <hr />
                </b-col>
            </b-row>

            <b-row>
                <b-col md="2" sm="4" class="my-1">
                    <b-form-group class="mb-0">
                        <label class="d-inline-block text-sm-left mr-50"
                            >Per page</label
                        >
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
                                <b-button
                                    :disabled="!filter"
                                    @click="filter = ''"
                                >
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
                                        <span class="font-weight-bolder"
                                            >ประเภท :</span
                                        >
                                        <span>{{ row.item.categoryName }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >เลขที่ :</span
                                        >
                                        <span>{{ row.item.bookFromNo }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ลงวันที่ :</span
                                        >
                                        <span>{{ row.item.bookFromDate }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >เรื่อง :</span
                                        >
                                        <span>{{ row.item.title }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >หน่วยงาน(ต้นทาง) :</span
                                        >
                                        <span>{{ row.item.bookFrom }}</span>
                                    </b-col>
                                    <b-col md="12" class="mb-1">
                                        <hr />
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >เลขรับ :</span
                                        >
                                        <span>{{ row.item.bookNo }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >วันที่รับ :</span
                                        >
                                        <span>{{ row.item.dateReceive }}</span>
                                    </b-col>

                                    <b-col
                                        md="4"
                                        class="mb-1"
                                    >
                                        <span class="font-weight-bolder"
                                            >ฝ่ายที่เกี่ยวข้อง :</span
                                        >
                                        <span>{{
                                            row.item.departmentName
                                        }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >หมายเหตุ :</span
                                        >
                                        <span>{{ row.item.detail }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ผู้ที่เกี่ยวข้อง (ส่งเมล) :</span
                                        >
                                        <span>{{ row.item.bookTo }}</span>
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

                        <!-- <template #cell(favorite)="row">
              <b-button
                :variant="`${resolveFavoriteVariant(row.item.favorite)}`"
                alt="Favorite"
                title="Favorite"
                class="btn-icon btn-sm"
                @click="onFavoriteChange(row.item.id, row.item.favorite)"
              >
                <feather-icon icon="StarIcon" style="margin-bottom: -2px" />
              </b-button>
            </template> -->

                        <template #cell(file)="data">
                            <b-button
                                variant="outline-primary"
                                alt="เปิดเอกสาร"
                                title="เปิดเอกสาร"
                                class="btn-icon btn-sm"
                                target="_blank"
                                :href="data.value"
                            >
                                <feather-icon
                                    icon="FileIcon"
                                    style="margin-bottom: -2px"
                                />
                                <span class="d-none d-xl-inline"
                                    >เปิดเอกสาร</span
                                >
                            </b-button>
                        </template>

                        <template #cell(fileSuccess)="data">
                            <b-button
                                variant="outline-success"
                                alt="เปิดเอกสาร"
                                title="เปิดเอกสาร"
                                class="btn-icon btn-sm"
                                target="_blank"
                                :href="data.value"
                                v-if="data.value != '-'"
                            >
                                <feather-icon
                                    icon="FileIcon"
                                    style="margin-bottom: -2px"
                                />
                                <span class="d-none d-xl-inline"
                                    >เปิดเอกสาร</span
                                >
                            </b-button>
                            <span v-if="data.value == '-'">-</span>
                        </template>

                        <template #cell(action)="row">
                            <b-button
                                variant="outline-warning"
                                alt="ดูข้อมูล"
                                title="ดูข้อมูล"
                                class="btn-icon btn-sm"
                                @click="row.toggleDetails"
                            >
                                <feather-icon
                                    icon="EyeIcon"
                                    style="margin-bottom: -2px"
                                />
                            </b-button>
                            <b-button
                                v-if="showBtnAdmin"
                                variant="outline-success"
                                alt="แก้ไข"
                                title="แก้ไข"
                                class="btn-icon btn-sm"
                                @click="
                                    $router.push({
                                        name: 'bookin-edit',
                                        params: { id: row.item.id },
                                    })
                                "
                            >
                                <feather-icon
                                    icon="EditIcon"
                                    style="margin-bottom: -2px"
                                />
                            </b-button>
                            <b-button
                                v-if="showBtnAdmin"
                                @click="onConfirmDelete(row.item.id)"
                                variant="outline-danger"
                                alt="ลบ"
                                title="ลบ"
                                class="btn-icon btn-sm"
                            >
                                <feather-icon
                                    icon="TrashIcon"
                                    style="margin-bottom: -2px"
                                />
                            </b-button>
                        </template>

                        <!-- <template #cell(status)="data">
            <b-badge :variant="status[1][data.value]">
              {{ status[0][data.value] }}
            </b-badge>
          </template> -->
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
    BModal,
    VBModal,
    BCardText,
} from "bootstrap-vue";
import vSelect from "vue-select";
import Ripple from "vue-ripple-directive";
import flatPickr from "vue-flatpickr-component";
import { Thai } from "flatpickr/dist/l10n/th.js";

import store from "@/store";
import useBookInList from "./useBookInList";
import bookInStoreModule from "./bookInStoreModule";
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
        flatPickr,
        vSelect,
        BFormRating,
        BModal,
        BCardText,
    },
    directives: {
        "b-modal": VBModal,
        Ripple,
    },
    data() {
        return {
            configDate: {
                mode: "single",
                altInput: true,
                altFormat: "j M Y",
                dateFormat: "Y-m-d",
                locale: Thai,
            },
        };
    },
    setup() {
        const BOOK_IN_LIST_APP_STORE_MODULE_NAME = "book-in-list";

        // Register module
        if (!store.hasModule(BOOK_IN_LIST_APP_STORE_MODULE_NAME))
            store.registerModule(
                BOOK_IN_LIST_APP_STORE_MODULE_NAME,
                bookInStoreModule
            );

        // UnRegister on leave
        onUnmounted(() => {
            if (store.hasModule(BOOK_IN_LIST_APP_STORE_MODULE_NAME))
                store.unregisterModule(BOOK_IN_LIST_APP_STORE_MODULE_NAME);
        });

        const {
            resolveFavoriteVariant,
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
            showBtnAdmin,
            advancedSearch,
            selectOptions,
            onFavoriteChange,
            exportDate,
            onExportExcel,
        } = useBookInList();

        return {
            resolveFavoriteVariant,
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
            showBtnAdmin,
            advancedSearch,
            selectOptions,
            onFavoriteChange,
            exportDate,
            onExportExcel,
        };
    },
};
</script>

<style lang="scss">
@import "@core/scss/vue/libs/vue-select.scss";
@import "@core/scss/vue/libs/vue-flatpicker.scss";

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
