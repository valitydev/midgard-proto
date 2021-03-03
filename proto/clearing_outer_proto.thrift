namespace java com.rbkmoney.midgard
namespace erlang midgard

include "base.thrift"

/** ID провайдера */
typedef i32 ProviderID
/** ID события на стороне вызывающего сервиса */
typedef i64 EventID

/** Команда, поступающая от внешнего сервиса */
struct ClearingEvent {
    1: required EventID           event_id
    2: required ProviderID        provider_id
}

/** Ответ от сервиса клиринга */
struct ClearingEventStateResponse {
    1: required EventID                    event_id
    2: required base.ClearingEventState    clearing_state
    3: optional ProviderID                 provider_id
    4: optional base.ClearingID            clearing_id
}

struct ClearingOperationInfo {
    1: required string                       invoice_id
    2: required string                       payment_id
    3: optional string                       refund_id
    4: optional base.Amount                  amount
    5: optional base.ClearingOperationType   transaction_type
    6: optional base.Integer                 version
}

exception NoClearingEvent {}

exception ProviderNotFound {}

/** Интерфейс взаимодействия между внешней системой и клиринговым сервисом */
service ClearingService {
    /** Запуск события в клиринговом сервисе */
    void StartClearingEvent(1: ClearingEvent clearing_event) throws (1: ProviderNotFound ex1)
    /** Получение статуса клирингового события */
    ClearingEventStateResponse GetClearingEventState(1: ProviderID provider_id, 2: EventID event_id) throws (1: NoClearingEvent ex1)
    /** Повторно отправить клиринговый файл для провайдера за определенный день (формат даты YYYY-MM-DD) */
    void ResendClearingFile(1: ProviderID provider_id, 2: EventID event_id) throws (1: NoClearingEvent ex1)
    /** Отменить отправленную в клиринге операцию */
    void ReverseClearingOperation(1: ClearingOperationInfo clearing_operation_info);
}