namespace myapp.Controllers
{
    using System.Runtime.Serialization;

    [DataContract]
    public class HomeControllerViewModel {
        [DataMember]
        public string Name 
        {
            get;
            set;
        }

        [DataMember]
        public string HostName 
        {
            get;
            set;
        }

        [DataMember]
        public int Visits
        {
            get;
            set;
        }
    }
}