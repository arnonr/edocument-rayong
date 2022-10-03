<template>
  <b-card>
    <validation-observer ref="simpleRules">
      <b-form>
        <b-row>
          <b-col cols="12">
            <b-form-group
              label="คำนำหน้า"
              label-for="h-prefix"
              label-cols-md="4"
            >
              <validation-provider
                name="prefix"
                rules="required"
                #default="{ errors }"
              >
                <b-form-input
                  id="h-prefix"
                  placeholder="Prefix"
                  v-model="profileData.prefix"
                />
                <small class="text-danger">{{ errors[0] }}</small>
              </validation-provider>
            </b-form-group>
          </b-col>
          <b-col cols="12">
            <b-form-group
              label="ชื่อ"
              label-for="h-first-name"
              label-cols-md="4"
            >
              <validation-provider
                name="firstname"
                rules="required"
                #default="{ errors }"
              >
                <b-form-input
                  id="h-first-name"
                  placeholder="First Name"
                  v-model="profileData.firstname"
                />
                <small class="text-danger">{{ errors[0] }}</small>
              </validation-provider>
            </b-form-group>
          </b-col>
          <b-col cols="12">
            <b-form-group
              label="นามสกุล"
              label-for="h-last-name"
              label-cols-md="4"
            >
              <validation-provider
                name="lastname"
                rules="required"
                #default="{ errors }"
              >
                <b-form-input
                  id="h-last-name"
                  placeholder="Last Name"
                  v-model="profileData.lastname"
                />
                <small class="text-danger">{{ errors[0] }}</small>
              </validation-provider>
            </b-form-group>
          </b-col>
          <b-col cols="12">
            <b-form-group label="Email" label-for="h-email" label-cols-md="4">
              <validation-provider
                name="email"
                rules="required|email"
                #default="{ errors }"
              >
                <b-form-input
                  id="h-email"
                  type="email"
                  placeholder="Email"
                  v-model="profileData.email"
                />
                <small class="text-danger">{{ errors[0] }}</small>
              </validation-provider>
            </b-form-group>
          </b-col>

          <b-col cols="12" style="margin-bottom: 1rem">
            <b-row>
              <b-col md="4"><span>ฝ่ายงาน</span></b-col>
              <b-col
                ><span>{{ profileData.department.name }}</span></b-col
              >
            </b-row>
          </b-col>

          <b-col cols="12" style="margin-bottom: 1rem">
            <b-row>
              <b-col md="4"><span>ประเภทผู้ใช้</span></b-col>
              <b-col>
                <b-badge
                  :variant="`light-${resolveUserTypeVariant(profileData.type)}`"
                >
                  {{ profileData.type }}
                </b-badge></b-col
              >
            </b-row>
          </b-col>

          <b-col cols="12" style="margin-bottom: 1rem">
            <b-row>
              <b-col md="4"><span>สถานะผู้ใช้</span></b-col>
              <b-col>
                <b-badge
                  :variant="`light-${
                    resolveUserStatusVariant(profileData.status)[1]
                  }`"
                >
                  {{ resolveUserStatusVariant(profileData.status)[0] }}
                </b-badge></b-col
              >
            </b-row>
          </b-col>

          <!-- submit and reset -->
          <b-col offset-md="4">
            <b-button
              v-ripple.400="'rgba(255, 255, 255, 0.15)'"
              type="submit"
              variant="primary"
              @click.prevent="validationForm"
              class="mr-1"
            >
              Submit
            </b-button>
          </b-col>
        </b-row>
      </b-form>
    </validation-observer>
  </b-card>
</template>

<script>
import {
  BRow,
  BCol,
  BFormGroup,
  BFormInput,
  BFormCheckbox,
  BForm,
  BButton,
  BCard,
  BBadge,
} from "bootstrap-vue";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import { required, email } from "@validations";
import Ripple from "vue-ripple-directive";

import { onUnmounted } from "@vue/composition-api";
import store from "@/store";
import profileStoreModule from "./profileStoreModule";
import useProfile from "./useProfile";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
    required,
    email,
    BRow,
    BCol,
    BFormGroup,
    BFormInput,
    BFormCheckbox,
    BForm,
    BButton,
    BCard,
    BBadge,
  },
  directives: {
    Ripple,
  },
  setup() {
    const PROFILE_EDIT_APP_STORE_MODULE_NAME = "profile-edit";

    // Register module
    if (!store.hasModule(PROFILE_EDIT_APP_STORE_MODULE_NAME))
      store.registerModule(
        PROFILE_EDIT_APP_STORE_MODULE_NAME,
        profileStoreModule
      );

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(PROFILE_EDIT_APP_STORE_MODULE_NAME))
        store.unregisterModule(PROFILE_EDIT_APP_STORE_MODULE_NAME);
    });

    const {
      profileData,
      resolveUserTypeVariant,
      resolveUserStatusVariant,
      validationForm,
      simpleRules,
    } = useProfile();

    return {
      profileData,
      resolveUserTypeVariant,
      resolveUserStatusVariant,
      validationForm,
      simpleRules,
    };
  },
};
</script>
