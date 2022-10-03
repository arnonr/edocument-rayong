<template>
    <div>
        <b-card>
            <b-row>
                <b-col md="12">
                    <b-form-group label="เลือกปี" label-for="">
                        <v-select
                            v-model="yearID"
                            :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                            label="title"
                            :clearable="false"
                            :options="selectOptions.year"
                        />
                    </b-form-group>
                </b-col>
            </b-row>
        </b-card>

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
                            v-model="advancedSearch.bookTypeName"
                            :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                            label="title"
                            :clearable="false"
                            placeholder="-- ประเภทเอกสาร --"
                            :options="selectOptions.bookType"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="4">
                    <b-form-group label="เลขที่" label-for="">
                        <b-form-input
                            id="bookFromNo"
                            v-model="advancedSearch.bookNo"
                            placeholder="เลขที่เอกสาร"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="4">
                    <b-form-group label="ลงวันที่" label-for="">
                        <flat-pickr
                            v-model="advancedSearch.dateSend"
                            placeholder="ลงวันที่"
                            class="form-control"
                            :config="configDate"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="6">
                    <b-form-group label="ถึง" label-for="">
                        <b-form-input
                            id="sendTo"
                            v-model="advancedSearch.toSend"
                            placeholder="ถึง"
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

                <b-col md="3">
                    <b-form-group label="ผู้รับผิดชอบ" label-for="">
                        <b-form-input
                            id="bookNo"
                            v-model="advancedSearch.fullName"
                            placeholder="ผู้รับผิดชอบ"
                        />
                    </b-form-group>
                </b-col>

                <!-- <b-col md="4">
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
        </b-col> -->

                <b-col md="3" v-if="showBtnAdmin">
                    <b-form-group label="สถานะเอกสาร" label-for="">
                        <v-select
                            v-model="advancedSearch.statusName"
                            :dir="$store.state.appConfig.isRTL ? 'rtl' : 'ltr'"
                            label="title"
                            placeholder="-- สถานะเอกสาร --"
                            :clearable="false"
                            :options="selectOptions.status"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="3">
                    <b-form-group label="วันที่สารบรรณรับเอกสาร" label-for="">
                        <flat-pickr
                            v-model="advancedSearch.dateReceive"
                            placeholder="วันที่สารบรรณรับเอกสาร"
                            class="form-control"
                            :config="configDate"
                        />
                    </b-form-group>
                </b-col>

                <b-col md="3">
                    <b-form-group label="วันที่คืนเอกสาร" label-for="">
                        <flat-pickr
                            v-model="advancedSearch.dateReturn"
                            placeholder="วันที่คืนเอกสาร"
                            class="form-control"
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
                        variant="success"
                        class="mb-sm-0 mr-0"
                        @click="$router.push({ name: 'bookout-old-add', query: {year: yearID.code} })"
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
                                        <span>{{ row.item.bookTypeName }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >เลขที่ :</span
                                        >
                                        <span>{{ row.item.bookNo }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ลงวันที่ :</span
                                        >
                                        <span>{{ row.item.dateSend }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ถึง :</span
                                        >
                                        <span>{{ row.item.toSend }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >เรื่อง :</span
                                        >
                                        <span>{{ row.item.title }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <hr />
                                    </b-col>

                                    <b-col md="6" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ผู้รับผิดชอบ :</span
                                        >
                                        <span>{{ row.item.fullName }}</span>
                                    </b-col>

                                    <b-col md="6" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ฝ่ายที่เกี่ยวข้อง :</span
                                        >
                                        <span>{{
                                            row.item.departmentName
                                        }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >วันที่สารบรรณรับเอกสาร :</span
                                        >
                                        <span>{{ row.item.dateReceive }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >วันที่คืนเอกสาร :</span
                                        >
                                        <span>{{ row.item.dateReturn }}</span>
                                    </b-col>

                                    <b-col md="4" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >สถานะ :</span
                                        >
                                        <b-badge
                                            :variant="row.item.status['color']"
                                        >
                                            {{ row.item.status["title"] }}
                                        </b-badge>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >หมายเหตุ :</span
                                        >
                                        <span>{{ row.item.detail }}</span>
                                    </b-col>

                                    <b-col md="12" class="mb-1">
                                        <span class="font-weight-bolder"
                                            >ส่งเมล :</span
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

                        <template #cell(status)="data">
                            <b-badge :variant="data.value['color']">
                                {{ data.value["title"] }}
                            </b-badge>
                        </template>

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

                        <template #cell(btnChangeStatus)="row">
                            <b-button
                                variant="outline-info"
                                alt="รับเรื่อง"
                                title="รับเรื่อง"
                                class="btn-icon btn-sm"
                                v-if="
                                    row.item.status['id'] == 1 && showBtnAdmin
                                "
                                @click="onChangeStatus(row.item.id, 2)"
                            >
                                <span>รับเรื่อง</span>
                            </b-button>

                            <b-button
                                variant="outline-success"
                                alt="รับเอกสาร"
                                title="รับเอกสาร"
                                class="btn-icon btn-sm"
                                v-if="
                                    row.item.status['id'] == 3 &&
                                    row.item.userID == userID
                                "
                                @click="onChangeStatus(row.item.id, 4)"
                            >
                                <span>รับเอกสาร</span>
                            </b-button>
                            <span
                                v-if="
                                    (row.item.status['id'] == 3 &&
                                        row.item.userID != userID) ||
                                    row.item.status['id'] == 2
                                "
                            >
                                -
                            </span>
                            <span
                                v-if="
                                    row.item.status['id'] == 4 &&
                                    row.item.dateReturn != null
                                "
                            >
                                {{ row.item.dateReturn }}
                            </span>
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
                                        name: 'bookout-old-edit',
                                        params: { id: row.item.id,yearID: yearID },
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
    BCardTitle,
} from "bootstrap-vue";
import vSelect from "vue-select";
import flatPickr from "vue-flatpickr-component";
import { Thai } from "flatpickr/dist/l10n/th.js";
import Ripple from "vue-ripple-directive";

import store from "@/store";
import useBookOutOld from "./useBookOutOld";
import bookOutStoreModule from "../bookOutStoreModule";
import { onUnmounted } from "@vue/composition-api";
import { getUserData } from "@/auth/utils";

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
        BCardTitle,
        BForm,
        flatPickr,
        vSelect,
        BFormRating,
        BModal,
        VBModal,
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
        const BOOK_OUT_OLD_APP_STORE_MODULE_NAME = "book-out-old";

        // Register module
        if (!store.hasModule(BOOK_OUT_OLD_APP_STORE_MODULE_NAME))
            store.registerModule(
                BOOK_OUT_OLD_APP_STORE_MODULE_NAME,
                bookOutStoreModule
            );

        // UnRegister on leave
        onUnmounted(() => {
            if (store.hasModule(BOOK_OUT_OLD_APP_STORE_MODULE_NAME))
                store.unregisterModule(BOOK_OUT_OLD_APP_STORE_MODULE_NAME);
        });

        //

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
            onChangeStatus,
            exportDate,
            onExportExcel,
            statusCount,
            yearID,
        } = useBookOutOld();

        let userID = getUserData().userID;

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
            onChangeStatus,
            userID,
            exportDate,
            onExportExcel,
            statusCount,
            yearID,
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
