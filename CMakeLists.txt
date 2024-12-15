cmake_minimum_required(VERSION 3.18)
if (ARCH_TARGET STREQUAL "arm32")
    message(STATUS "ARM INDEED!")

    set(CMAKE_SYSTEM_PROCESSOR arm)

    set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
    set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
elseif(ARCH_TARGET STREQUAL "riscv64")
    message(STATUS "RISCV SELECTED!")

    set(CMAKE_SYSTEM_PROCESSOR riscv64)

    set(CMAKE_C_COMPILER /usr/bin/riscv64-linux-gnu-gcc) 
    set(CMAKE_CXX_COMPILER /usr/bin/riscv64-linux-gnu-g++)

    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
else()
    message(STATUS "X86_64 INSTEAD OF ARM!")
endif()

set(CMAKE_CXX_STANDARD 17) # limited to 17 because of the toolchain T.T
set(CMAKE_SYSTEM_NAME Linux)


# Flags de compilação por tipo
set(CMAKE_C_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -Wall -Wextra -pedantic")
set(CMAKE_C_FLAGS_RELEASE "-O3")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -Wall -Wextra")
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")

project(eesc-aero-embedded-systems)

find_package(PkgConfig REQUIRED)
#find_package(Threads REQUIRED)

pkg_check_modules(LELY-COAPP REQUIRED IMPORTED_TARGET liblely-coapp)
#set(THREADS_PREFER_PTHREAD_FLAG ON)
#find_package(Threads REQUIRED)

#set(CMAKE_EXE_LINKER_FLAGS "-static")

#set(CMAKE_CXX_FLAGS "--coverage")

#target_link_libraries(${PROJECT_NAME} Threads::Threads)
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
add_executable(${PROJECT_NAME} main.cpp ManoplaLelyBBB.cpp utils/utils.cpp utils/json.h)

if (ARCH_TARGET STREQUAL "arm32")
    target_include_directories(${PROJECT_NAME} PRIVATE 
        /lely-core/install-arm-docker-debian-11/include
    )
elseif (ARCH_TARGET STREQUAL "riscv64")
    target_include_directories(${PROJECT_NAME} PRIVATE 
        /lely-core/install-riscv64-docker-debian-11/include
    )
else()
    target_include_directories(${PROJECT_NAME} PRIVATE 
        /lely-core/install-x86_64-docker-debian-11/include
    )
endif()

# Diretório da Lely Core que foi buildada dentro do Docker
target_include_directories(${PROJECT_NAME} PRIVATE
    /usr/lib
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${LELY-COAPP_LIBRARIES} blas /usr/lib/libarmadillo.so.10.1.2)

target_link_directories(${PROJECT_NAME} PRIVATE ${LELY-COAPP_LIBDIR})
target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -pedantic -g3)
if (ARCH_TARGET == "arm32")
    target_include_directories(${PROJECT_NAME} PRIVATE ${LELY-COAPP_INCLUDEDIR})
    #target_include_directories(${PROJECT_NAME} PRIVATE ${BBB_DEBIAN_11_SYSROOT}/usr/include)
endif ()
target_include_directories(${PROJECT_NAME} PRIVATE utils)#target_include_directories(${PROJECT_NAME} PRIVATE ./gnuplot-iostream)
#install(CODE "execute_process(COMMAND scp ${CMAKE_BINARY_DIR}/${PROJECT_NAME} debian@192.168.7.2:/home/debian/${PROJECT_NAME})")
