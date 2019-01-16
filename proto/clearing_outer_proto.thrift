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
    3: optional base.Timestamp    date_from
    4: optional base.Timestamp    date_to
}

/** Ответ от сервиса клиринга */
struct ClearingEventStateResponse {
    1: required EventID                    event_id
    2: required base.ClearingEventState    clearing_state
    3: optional ProviderID                 provider_id
    4: optional base.ClearingID            clearing_id
}

exception NoClearingEvent {}

/** Интерфейс взаимодействия между внешней системой и клиринговым сервисом */
service ClearingService {
    /** Запуск события в клиринговом сервисе */
    void StartClearingEvent(1: ClearingEvent clearingEvent) throws ()
    /** Получение статуса клирингового события */
    ClearingEventStateResponse GetClearingEventState(1: EventID event_id) throws (1: NoClearingEvent ex1)
}