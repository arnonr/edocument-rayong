<template>
    <div class="navbar-container d-flex content align-items-center">
        <!-- Nav Menu Toggler -->
        <ul class="nav navbar-nav d-xl-none">
            <li class="nav-item">
                <b-link class="nav-link" @click="toggleVerticalMenuActive">
                    <feather-icon icon="MenuIcon" size="21" />
                </b-link>
            </li>
        </ul>

        <!-- Left Col -->
        <div
            class="bookmark-wrapper align-items-center flex-grow-1 d-none d-lg-flex"
        >
            <dark-Toggler class="d-none d-lg-block" />
            <!-- <div class="align-center text-warning"> -->

            <!-- </div> -->
        </div>
        <div>
            <a
                class="text-danger d-lg-block mr-5"
                style="float: center"
                @click="
                    $router.push({
                        name: 'bookout',
                        query: { status: 'รอสารบรรณรับเรื่อง' },
                    })
                "
            >
                <span>{{ notification }}</span></a
            >
        </div>

        <b-navbar-nav class="nav align-items-center ml-auto">
            <b-nav-item-dropdown
                right
                toggle-class="d-flex align-items-center dropdown-user-link"
                class="dropdown-user"
            >
                <template #button-content>
                    <div class="d-sm-flex d-none user-nav">
                        <p class="user-name font-weight-bolder mb-0">
                            {{ userData ? userData.fullName : "" }}
                        </p>
                        <span class="user-status">{{
                            userData ? userData.type : ""
                        }}</span>
                    </div>
                    <b-avatar
                        size="40"
                        variant="light-primary"
                        badge
                        class="badge-minimal"
                        badge-variant="success"
                    />
                    <!-- :src="require('@/assets/images/avatars/13-small.png')" -->
                </template>

                <b-dropdown-item
                    link-class="d-flex align-items-center"
                    @click="logout"
                >
                    <feather-icon size="16" icon="LogOutIcon" class="mr-50" />
                    <span>Logout</span>
                </b-dropdown-item>
            </b-nav-item-dropdown>
        </b-navbar-nav>
    </div>
</template>

<script>
import {
    BLink,
    BNavbarNav,
    BNavItemDropdown,
    BDropdownItem,
    BDropdownDivider,
    BAvatar,
} from "bootstrap-vue";
import DarkToggler from "@core/layouts/components/app-navbar/components/DarkToggler.vue";
import { initialAbility } from "@/libs/acl/config";
import useJwt from "@/auth/jwt/useJwt";
import { avatarText } from "@core/utils/filter";
import axios from "@axios";
import { onMounted, ref } from "@vue/composition-api";
import { getUserData } from "@/auth/utils";

export default {
    components: {
        BLink,
        BNavbarNav,
        BNavItemDropdown,
        BDropdownItem,
        BDropdownDivider,
        BAvatar,
        // Navbar Components
        DarkToggler,
    },
    props: {
        toggleVerticalMenuActive: {
            type: Function,
            default: () => {},
        },
    },
    data() {
        return {
            userData: JSON.parse(localStorage.getItem("userData")),
            avatarText,
        };
    },
    methods: {
        logout() {
            // console.log(localStorage.getItem('userData'))

            // Remove userData from localStorage
            // ? You just removed token from localStorage. If you like, you can also make API call to backend to blacklist used token
            localStorage.removeItem(useJwt.jwtConfig.storageTokenKeyName);
            localStorage.removeItem(
                useJwt.jwtConfig.storageRefreshTokenKeyName
            );

            // Remove userData from localStorage
            localStorage.removeItem("userData");

            // Reset ability
            this.$ability.update(initialAbility);

            // Redirect to login page
            this.$router.push({ name: "auth-login" });
        },
    },
    setup() {
        const notification = ref(null);

        onMounted(() => {
            if (getUserData().type == "admin") {
                // setInterval(function () {
                //     axios.get(`/bookOut`).then(function (response) {
                //         const { bookOut } = response.data;
                //         let checkNoti = bookOut.filter((x) => {
                //             if (x.statusTitle == "รอสารบรรณรับเรื่อง") {
                //                 return true;
                //             } else {
                //                 return false;
                //             }
                //         });
                //         console.log(checkNoti.length);
                //         if (checkNoti.length > 0) {
                //             notification.value = `แจ้งเตือน: มีหนังสือรอการรับเรื่อง ${checkNoti.length} ฉบับ`;
                //         }else{
                //             notification.value = null;
                //         }
                //     });
                // }, 10000);
            }
        });

        return { notification };
    },
};
</script>
