from fastapi import APIRouter, Header, Depends
from app.database import get_database
from app.schemas.sos_schemas import MeshRelayIn, SOSOut
from app.services.sos_pipeline_service import create_sos_event
from app.constants import DeliveryTier
from app.config import settings
from app.exceptions import UnauthorizedException

router = APIRouter()


@router.post("/relay-exit", response_model=SOSOut, status_code=201)
async def relay_exit(
    payload: MeshRelayIn,
    x_mesh_key: str = Header(None),
    db=Depends(get_database),
):
    if x_mesh_key != settings.MESH_GATEWAY_API_KEY:
        raise UnauthorizedException("Invalid mesh gateway key")

    event = await create_sos_event(
        db=db,
        user_id=payload.user_id,
        event_type=payload.event_type,
        location=payload.location.model_dump(),
        delivered_via=DeliveryTier.MESH.value,
        origin_meta={"hop_count": payload.hop_count, "relay_chain": payload.relay_chain},
    )
    return event