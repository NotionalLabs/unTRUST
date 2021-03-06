cdef extern from "libimobiledevice/lockdown.h":
    ctypedef enum lockdownd_error_t:
        LOCKDOWN_E_SUCCESS = 0
        LOCKDOWN_E_INVALID_ARG = -1
        LOCKDOWN_E_INVALID_CONF = -2
        LOCKDOWN_E_PLIST_ERROR = -3
        LOCKDOWN_E_PAIRING_FAILED = -4
        LOCKDOWN_E_SSL_ERROR = -5
        LOCKDOWN_E_DICT_ERROR = -6
        LOCKDOWN_E_START_SERVICE_FAILED = -7
        LOCKDOWN_E_NOT_ENOUGH_DATA = -8
        LOCKDOWN_E_SET_VALUE_PROHIBITED = -9
        LOCKDOWN_E_GET_VALUE_PROHIBITED = -10
        LOCKDOWN_E_REMOVE_VALUE_PROHIBITED = -11
        LOCKDOWN_E_MUX_ERROR = -12
        LOCKDOWN_E_ACTIVATION_FAILED = -13
        LOCKDOWN_E_PASSWORD_PROTECTED = -14
        LOCKDOWN_E_NO_RUNNING_SESSION = -15
        LOCKDOWN_E_INVALID_HOST_ID = -16
        LOCKDOWN_E_INVALID_SERVICE = -17
        LOCKDOWN_E_INVALID_ACTIVATION_RECORD = -18
        LOCKDOWN_E_UNKNOWN_ERROR = -256

    lockdownd_error_t lockdownd_client_new(idevice_t device, lockdownd_client_t *client, char *label)
    lockdownd_error_t lockdownd_client_new_with_handshake(idevice_t device, lockdownd_client_t *client, char *label)
    lockdownd_error_t lockdownd_client_free(lockdownd_client_t client)

    lockdownd_error_t lockdownd_query_type(lockdownd_client_t client, char **tp)
    lockdownd_error_t lockdownd_get_value(lockdownd_client_t client, char *domain, char *key, plist.plist_t *value)
    lockdownd_error_t lockdownd_set_value(lockdownd_client_t client, char *domain, char *key, plist.plist_t value)
    lockdownd_error_t lockdownd_remove_value(lockdownd_client_t client, char *domain, char *key)
    lockdownd_error_t lockdownd_start_service(lockdownd_client_t client, char *identifier, lockdownd_service_descriptor_t *service)
    lockdownd_error_t lockdownd_start_session(lockdownd_client_t client, char *host_id, char **session_id, int *ssl_enabled)
    lockdownd_error_t lockdownd_stop_session(lockdownd_client_t client, char *session_id)
    lockdownd_error_t lockdownd_send(lockdownd_client_t client, plist.plist_t plist)
    lockdownd_error_t lockdownd_receive(lockdownd_client_t client, plist.plist_t *plist)
    lockdownd_error_t lockdownd_pair(lockdownd_client_t client, lockdownd_pair_record_t pair_record)
    lockdownd_error_t lockdownd_validate_pair(lockdownd_client_t client, lockdownd_pair_record_t pair_record)
    lockdownd_error_t lockdownd_unpair(lockdownd_client_t client, lockdownd_pair_record_t pair_record)
    lockdownd_pair_record_t pair_record_get_current(lockdownd_client_t client)
    lockdownd_error_t lockdownd_activate(lockdownd_client_t client, plist.plist_t activation_record)
    lockdownd_error_t lockdownd_deactivate(lockdownd_client_t client)
    lockdownd_error_t lockdownd_enter_recovery(lockdownd_client_t client)
    lockdownd_error_t lockdownd_goodbye(lockdownd_client_t client)
    lockdownd_error_t lockdownd_get_sync_data_classes(lockdownd_client_t client, char ***classes, int *count)
    lockdownd_error_t lockdownd_data_classes_free(char **classes)
    lockdownd_error_t lockdownd_service_descriptor_free(lockdownd_service_descriptor_t service)

cdef class LockdownError(BaseError):
    def __init__(self, *args, **kwargs):
        self._lookup_table = {
            LOCKDOWN_E_SUCCESS: "Success",
            LOCKDOWN_E_INVALID_ARG: "Invalid argument",
            LOCKDOWN_E_INVALID_CONF: "Invalid configuration",
            LOCKDOWN_E_PLIST_ERROR: "Property list error",
            LOCKDOWN_E_PAIRING_FAILED: "Pairing failed",
            LOCKDOWN_E_SSL_ERROR: "SSL error",
            LOCKDOWN_E_DICT_ERROR: "Dict error",
            LOCKDOWN_E_START_SERVICE_FAILED: "Start service failed",
            LOCKDOWN_E_NOT_ENOUGH_DATA: "Not enough data",
            LOCKDOWN_E_SET_VALUE_PROHIBITED: "Set value prohibited",
            LOCKDOWN_E_GET_VALUE_PROHIBITED: "Get value prohibited",
            LOCKDOWN_E_REMOVE_VALUE_PROHIBITED: "Remove value prohibited",
            LOCKDOWN_E_MUX_ERROR: "MUX Error",
            LOCKDOWN_E_ACTIVATION_FAILED: "Activation failed",
            LOCKDOWN_E_PASSWORD_PROTECTED: "Password protected",
            LOCKDOWN_E_NO_RUNNING_SESSION: "No running session",
            LOCKDOWN_E_INVALID_HOST_ID: "Invalid host ID",
            LOCKDOWN_E_INVALID_SERVICE: "Invalid service",
            LOCKDOWN_E_INVALID_ACTIVATION_RECORD: "Invalid activation record",
            LOCKDOWN_E_UNKNOWN_ERROR: "Unknown error"
        }
        BaseError.__init__(self, *args, **kwargs)

cdef class LockdownPairRecord:
#   Added by Stroz Friedberg for unTRUST application on 8/8/14
    def __cinit__(self, bytes device_certificate, bytes host_certificate, bytes root_certificate, bytes host_id, bytes system_buid, *args, **kwargs):
        self._c_record = <lockdownd_pair_record_t>calloc(5, sizeof(char *))
        self._c_record.device_certificate = device_certificate
        self._c_record.host_certificate = host_certificate
        self._c_record.root_certificate = root_certificate
        self._c_record.host_id = host_id
        self._c_record.system_buid = system_buid
    
#   Added by Stroz Friedberg for unTRUST application on 8/8/14     
    def __dealloc__(self):
        pass
#        free(self._c_record.device_certificate)
#        free(self._c_record.host_certificate)
#        free(self._c_record.root_certificate)
#        free(self._c_record.host_id)
#        free(self._c_record.system_buid)
#        self._c_record = NULL

    property device_certificate:
        def __get__(self):
            cdef bytes result = self._c_record.device_certificate
            return result

    property host_certificate:
        def __get__(self):
            cdef bytes result = self._c_record.host_certificate
            return result

    property root_certificate:
        def __get__(self):
            cdef bytes result = self._c_record.root_certificate
            return result

    property host_id:
        def __get__(self):
            cdef bytes result = self._c_record.host_id
            return result

    property system_buid:
        def __get__(self):
            cdef bytes result = self._c_record.system_buid
            return result

cdef class LockdownServiceDescriptor(Base):
    #def __cinit__(self, uint16_t port, uint8_t ssl_enabled, *args, **kwargs):
    def __dealloc__(self):
        cdef lockdownd_error_t err
        if self._c_service_descriptor is not NULL:
            err = lockdownd_service_descriptor_free(self._c_service_descriptor)
            self._c_service_descriptor = NULL
            self.handle_error(err)
    property port:
        def __get__(self):
            return self._c_service_descriptor.port
    property ssl_enabled:
        def __get__(self):
            return self._c_service_descriptor.ssl_enabled

cdef class LockdownClient(PropertyListService):
    def __cinit__(self, iDevice device not None, bytes label=b'', bint handshake=True, *args, **kwargs):
        cdef:
            lockdownd_error_t err
            char* c_label = NULL
        if label:
            c_label = label
        if handshake:
            err = lockdownd_client_new_with_handshake(device._c_dev, &self._c_client, c_label)
        else:
            err = lockdownd_client_new(device._c_dev, &self._c_client, c_label)
        self.handle_error(err)

        self.device = device

    def __dealloc__(self):
#        print "Dealloc Lockdown Client"
        pass
#        cdef lockdownd_error_t err
#        if self._c_client is not NULL:
#            err = lockdownd_client_free(self._c_client)
#            self.handle_error(err)
    
    cpdef quit(self, int status):
        exit(0)

    cpdef bytes query_type(self):
        cdef:
            lockdownd_error_t err
            char* c_type = NULL
            bytes result
        err = lockdownd_query_type(self._c_client, &c_type)
        try:
            self.handle_error(err)
            result = c_type

            return result
        except BaseError, e:
            raise
        finally:
            if c_type != NULL:
                free(c_type)

    cpdef plist.Node get_value(self, bytes domain=None, bytes key=None):
        cdef:
            lockdownd_error_t err
            plist.plist_t c_node = NULL
            char* c_domain = NULL
            char* c_key = NULL
        if domain is not None:
            c_domain = domain
        if key is not None:
            c_key = key

        err = lockdownd_get_value(self._c_client, c_domain, c_key, &c_node)

        try:
            self.handle_error(err)

            return plist.plist_t_to_node(c_node)
        except BaseError, e:
            if c_node != NULL:
                plist.plist_free(c_node)
            raise

    cpdef set_value(self, bytes domain, bytes key, object value):
        cdef plist.plist_t c_node = plist.native_to_plist_t(value)
        try:
            self.handle_error(lockdownd_set_value(self._c_client, domain, key, c_node))
        except BaseError, e:
            raise
        finally:
            if c_node != NULL:
                plist.plist_free(c_node)

    cpdef remove_value(self, bytes domain, bytes key):
        self.handle_error(lockdownd_remove_value(self._c_client, domain, key))

    cpdef object start_service(self, object service):
        cdef:
            char* c_service_name = NULL
            lockdownd_service_descriptor_t c_descriptor = NULL
            LockdownServiceDescriptor result

        if issubclass(service, BaseService) and \
            service.__service_name__ is not None \
            and isinstance(service.__service_name__, basestring):
            c_service_name = <bytes>service.__service_name__
        elif isinstance(service, basestring):
            c_service_name = <bytes>service
        else:
            raise TypeError("LockdownClient.start_service() takes a BaseService or string as its first argument")

        try:
            self.handle_error(lockdownd_start_service(self._c_client, c_service_name, &c_descriptor))

            result = LockdownServiceDescriptor.__new__(LockdownServiceDescriptor)
            result._c_service_descriptor = c_descriptor

            return result
        except BaseError, e:
            raise

    cpdef object get_service_client(self, object service_class):
        cdef:
            LockdownServiceDescriptor descriptor

        if not hasattr(service_class, '__service_name__') and \
            not service_class.__service_name__ is not None \
            and not isinstance(service_class.__service_name__, basestring):
            raise TypeError("LockdownClient.get_service_client() takes a BaseService as its first argument")

        descriptor = self.start_service(service_class)
        return service_class(self.device, descriptor)

    cpdef tuple start_session(self, bytes host_id):
        cdef:
            lockdownd_error_t err
            char* c_session_id = NULL
            bint ssl_enabled
            bytes session_id
        err = lockdownd_start_session(self._c_client, host_id, &c_session_id, <int *>&ssl_enabled)
        try:
            self.handle_error(err)

            session_id = c_session_id
            return (session_id, ssl_enabled)
        except BaseError, e:
            raise
        finally:
            if c_session_id != NULL:
                free(c_session_id)

    cpdef stop_session(self, bytes session_id):
        self.handle_error(lockdownd_stop_session(self._c_client, session_id))

    cpdef pair(self, object pair_record=None):
        cdef lockdownd_pair_record_t c_pair_record = NULL
        if pair_record is not None:
            c_pair_record = (<LockdownPairRecord>pair_record)._c_record
        self.handle_error(lockdownd_pair(self._c_client, c_pair_record))

    cpdef validate_pair(self, object pair_record=None):
        cdef lockdownd_pair_record_t c_pair_record = NULL
        if pair_record is not None:
            c_pair_record = (<LockdownPairRecord>pair_record)._c_record
        self.handle_error(lockdownd_validate_pair(self._c_client, c_pair_record))

    cpdef unpair(self, object pair_record=None):
        cdef lockdownd_pair_record_t c_pair_record = NULL
        if pair_record is not None:
            c_pair_record = (<LockdownPairRecord>pair_record)._c_record
	
        self.handle_error(lockdownd_unpair(self._c_client, c_pair_record))
        free(c_pair_record)
        
#  Added by Stroz Friedberg for unTRUST application on 8/8/14 - gives direct access to the current pair record for the connection.        
    cpdef dict current_pair_record(self):
        cdef lockdownd_pair_record_t c_pair_record = pair_record_get_current(self._c_client)
        return {"DeviceCertificate": c_pair_record.device_certificate, "HostCertificate": c_pair_record.host_certificate, "HostID": c_pair_record.host_id, "RootCertificate": c_pair_record.root_certificate, "SystemBUID": c_pair_record.system_buid}

    cpdef activate(self, plist.Node activation_record):
        self.handle_error(lockdownd_activate(self._c_client, activation_record._c_node))

    cpdef deactivate(self):
        self.handle_error(lockdownd_deactivate(self._c_client))

    cpdef enter_recovery(self):
        self.handle_error(lockdownd_enter_recovery(self._c_client))

    cpdef goodbye(self):
        self.handle_error(lockdownd_goodbye(self._c_client))

    cpdef list get_sync_data_classes(self):
        cdef:
            char **classes = NULL
            int count = 0
            list result = []
            bytes data_class

        try:
            self.handle_error(lockdownd_get_sync_data_classes(self._c_client, &classes, &count))

            for i from 0 <= i < count:
                data_class = classes[i]
                result.append(data_class)

            return result
        except Exception, e:
            raise
        finally:
            if classes != NULL:
                lockdownd_data_classes_free(classes)

    cdef inline int16_t _send(self, plist.plist_t node):
        return lockdownd_send(self._c_client, node)

    cdef inline int16_t _receive(self, plist.plist_t* node):
        return lockdownd_receive(self._c_client, node)

    cdef inline BaseError _error(self, int16_t ret):
        return LockdownError(ret)
