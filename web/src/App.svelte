<script lang="ts">
    import Modal from "./lib/components/Modal.svelte";
    import Warning from "./lib/components/Warning.svelte";
    import { fetchNui } from "./lib/utils/FetchNui";
    import { useNuiEvent } from "./lib/utils/NuiEvents";
  
    // Warning
    function handleWarningAccept() {
        fetchNui('accepted:warning');
    }
  
    let warningOpen = false;
    let warningDescription = "Are you sure?";
    let warningAccept = "Yes";
    let warningDecline = "No";
  
    useNuiEvent('open:warning', function(data: any) {
        warningOpen = data?.visible || warningOpen;
    });
  
    // Modal
    function confirmModal() {
      fetchNui('confirmed:modal');
    }
  
    let modalOpen = true;
    let modalDescription = "Are you sure?";
    let modalConfirm = "Yes";
    let modalRangeLabel = "Amount:";
    let modalRange = { min: 0, max: 0 };
  
    useNuiEvent('open:modal', function(data: any) {
        modalOpen = data?.visible || modalOpen;
    });
</script>
  
<Warning 
    open={warningOpen} 
    description={warningDescription}
    accept={warningAccept}
    decline={warningDecline} 
    onAccept={handleWarningAccept} 
    onClose={() => warningOpen = false}
/>
  
<Modal
    open={modalOpen} 
    description={modalDescription}
    confirm={modalConfirm}
    rangeLabel={modalRangeLabel}
    range={modalRange}
    onConfirm={confirmModal} 
    onClose={() => modalOpen = false}
/>
  